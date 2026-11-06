extends Node

## Mantiene el balance municipal (fondos, ingresos, gastos) y expone
## operaciones de gasto/ingreso. Escucha EventBus para reaccionar a
## construcción/demolición y stats de población; nunca importa
## BuildingManager ni PopulationManager directamente.

var _tax_calculator := TaxCalculator.new()
var _budget := Budget.new()

var funds: int = 0


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


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar funds y allocations de _budget.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: restaurar funds y _budget desde el save.
	pass

# TODO Etapa 5: conectar a EventBus.building_placed/demolished (costo,
# mantenimiento) y a stats de PopulationManager (impuestos vía _tax_calculator).
