extends Node

## Valida y ejecuta la colocación/demolición de edificios sobre el grid.
## Única puerta de entrada al catálogo de BuildingData; nunca llama
## directamente a EconomyManager ni PopulationManager, solo emite eventos
## por EventBus para que esos módulos reaccionen si les interesa.

var catalog: Array[BuildingData] = []


func register_building(data: BuildingData) -> void:
	catalog.append(data)


func get_catalog() -> Array[BuildingData]:
	return catalog


func try_place_building(data: BuildingData, cell: Vector2i) -> bool:
	# TODO Etapa 3: validar GridManager.is_buildable, costo vs EconomyManager
	# (vía intención, no acople directo), instanciar building_base.tscn,
	# y emitir EventBus.building_placed.
	return false


func try_demolish(cell: Vector2i) -> bool:
	# TODO Etapa 3: liberar la celda en GridManager y emitir
	# EventBus.building_demolished.
	return false


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar lista de (building_id, cell) colocados.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: reconstruir edificios colocados a partir del save.
	pass
