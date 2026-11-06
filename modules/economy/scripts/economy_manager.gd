extends Node

## Mantiene el balance municipal (fondos, ingresos, gastos) y expone
## operaciones de gasto/ingreso. Escucha EventBus para reaccionar a
## construcción/demolición y stats de población; nunca importa
## BuildingManager ni PopulationManager directamente.

var _tax_calculator := TaxCalculator.new()
var _budget := Budget.new()

var funds: int = GameConstants.STARTING_FUNDS
var tax_rate: float = 1.0

var _commercial_tax_revenue: int = 0


func _ready() -> void:
	EventBus.building_placed.connect(_on_building_placed)
	EventBus.building_demolished.connect(_on_building_demolished)
	EventBus.simulation_tick.connect(_on_simulation_tick)


func get_funds() -> int:
	return funds


func try_spend(amount: int) -> bool:
	if amount > funds:
		return false
	funds -= amount
	EventBus.funds_changed.emit(funds)
	return true


func add_income(amount: int) -> void:
	funds += amount
	EventBus.funds_changed.emit(funds)


func set_tax_rate(rate: float) -> void:
	# EventBus.tax_rate_changed es por categoría (para cuando exista una tasa
	# por categoría); mientras tax_rate sea un único valor global, no hay un
	# BuildingCategory válido que emitir, así que no se usa esa señal todavía.
	tax_rate = rate


func get_save_data() -> Dictionary:
	return {"funds": funds, "tax_rate": tax_rate}


func load_save_data(data: Dictionary) -> void:
	# _commercial_tax_revenue y _budget NO se guardan: se reconstruyen solos
	# cuando BuildingManager reproduce los edificios guardados. Esto corre
	# al final de la carga (después de reproducir edificios), así que fija
	# el valor real de fondos por sobre el que haya dejado esa reproducción.
	funds = int(data.get("funds", GameConstants.STARTING_FUNDS))
	tax_rate = float(data.get("tax_rate", 1.0))
	EventBus.funds_changed.emit(funds)


func _on_building_placed(data: BuildingData, _cell: Vector2i) -> void:
	# No se valida aquí si alcanza: BuildingManager ya consultó get_funds()
	# antes de colocar. Esto solo aplica el descuento reactivo.
	try_spend(data.cost)
	if data is CommercialBuildingData:
		_commercial_tax_revenue += data.tax_revenue
	var key := _category_key(data.category)
	_budget.set_allocation(key, _budget.get_allocation(key) + data.maintenance_cost)


func _on_building_demolished(data: BuildingData, _cell: Vector2i) -> void:
	# Sin reembolso del costo de construcción (simplificación deliberada).
	if data is CommercialBuildingData:
		_commercial_tax_revenue -= data.tax_revenue
	var key := _category_key(data.category)
	_budget.set_allocation(key, _budget.get_allocation(key) - data.maintenance_cost)


func _on_simulation_tick(_tick: int) -> void:
	var income := _tax_calculator.calculate_income(
		PopulationManager.get_total_population(), _commercial_tax_revenue, tax_rate
	)
	var maintenance := _budget.get_total_allocated()
	# Ajuste neto único (en vez de try_spend + add_income por separado) para
	# emitir funds_changed una sola vez por tick. Los fondos pueden quedar
	# negativos: no hay bancarrota ni corte de servicios todavía (fuera de
	# alcance de esta etapa).
	funds += income - maintenance
	EventBus.funds_changed.emit(funds)


func _category_key(category: GameEnums.BuildingCategory) -> StringName:
	match category:
		GameEnums.BuildingCategory.RESIDENTIAL:
			return &"residential"
		GameEnums.BuildingCategory.COMMERCIAL:
			return &"commercial"
		GameEnums.BuildingCategory.INDUSTRIAL:
			return &"industrial"
		GameEnums.BuildingCategory.CIVIC:
			return &"civic"
		_:
			return &"other"
