extends Node

## Calcula población agregada por zona a partir de la capacidad de vivienda
## ocupada. Escucha EventBus.building_placed/demolished (residencial) y
## EventBus.service_coverage_changed para satisfacción; nunca referencia
## BuildingManager directamente.

var _housing := HousingCalculator.new()

var total_population: int = 0
var housing_capacity: int = 0


func _ready() -> void:
	EventBus.building_placed.connect(_on_building_placed)
	EventBus.building_demolished.connect(_on_building_demolished)
	EventBus.simulation_tick.connect(_on_simulation_tick)


func get_total_population() -> int:
	return total_population


func get_housing_demand() -> int:
	return _housing.calculate_demand(housing_capacity, total_population)


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar total_population y estado agregado por zona.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: restaurar total_population desde el save.
	pass


func _on_building_placed(data: BuildingData, _cell: Vector2i) -> void:
	if data is ResidentialBuildingData:
		housing_capacity += data.population_capacity


func _on_building_demolished(data: BuildingData, _cell: Vector2i) -> void:
	if data is ResidentialBuildingData:
		housing_capacity -= data.population_capacity
		# Simplificación deliberada (Etapa 4): si la capacidad baja de la
		# población actual, el excedente se ajusta de inmediato. No hay
		# mecánica de "población sin techo" todavía.
		if total_population > housing_capacity:
			total_population = housing_capacity
			EventBus.population_changed.emit(total_population)


func _on_simulation_tick(_tick: int) -> void:
	var growth := _housing.calculate_growth(housing_capacity, total_population)
	if growth <= 0:
		return
	total_population += growth
	EventBus.population_changed.emit(total_population)
