extends Node

## Calcula población agregada por zona a partir de la capacidad de vivienda
## ocupada. Escucha EventBus.building_placed/demolished (residencial) y
## EventBus.service_coverage_changed para satisfacción; nunca referencia
## BuildingManager directamente.

var _housing := HousingCalculator.new()

var total_population: int = 0


func get_total_population() -> int:
	return total_population


func get_housing_demand() -> int:
	return _housing.calculate_demand()


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar total_population y estado agregado por zona.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: restaurar total_population desde el save.
	pass

# TODO Etapa 4: conectar a EventBus.building_placed/demolished, recalcular
# con _housing y emitir EventBus.population_changed.
