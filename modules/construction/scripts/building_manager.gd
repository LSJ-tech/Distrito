extends Node

## Valida y ejecuta la colocación/demolición de edificios sobre el grid.
## Única puerta de entrada al catálogo de BuildingData; nunca llama
## directamente a EconomyManager ni PopulationManager, solo emite eventos
## por EventBus para que esos módulos reaccionen si les interesa.
## No cobra fondos todavía: EconomyManager real es Etapa 5.

const BUILDINGS_PATH: String = "res://data/buildings"
const BUILDING_BASE_SCENE: PackedScene = preload("res://modules/construction/scenes/building_base.tscn")

var catalog: Array[BuildingData] = []

## origin_cell (Vector2i) -> { "data": BuildingData, "node": BuildingInstance }
var placed_buildings: Dictionary = {}


func _ready() -> void:
	_scan_catalog(BUILDINGS_PATH)


func register_building(data: BuildingData) -> void:
	catalog.append(data)


func get_catalog() -> Array[BuildingData]:
	return catalog


func try_place_building(data: BuildingData, cell: Vector2i) -> bool:
	if data == null:
		return false
	if not GridManager.is_buildable(cell, data.footprint):
		return false
	if data.requires_road_adjacency and not GridManager.is_adjacent_to_road(cell, data.footprint):
		return false

	GridManager.place_building_ref(cell, data.id, data.footprint)
	var instance := _instantiate_building(data, cell)
	placed_buildings[cell] = {"data": data, "node": instance}
	EventBus.building_placed.emit(data, cell)
	return true


func try_demolish(cell: Vector2i) -> bool:
	var cell_data := GridManager.get_cell(cell)
	if cell_data == null or cell_data.building_id == &"":
		return false

	var origin := cell_data.building_origin
	if not placed_buildings.has(origin):
		return false

	var entry: Dictionary = placed_buildings[origin]
	var data: BuildingData = entry["data"]
	var node: Node2D = entry["node"]

	GridManager.clear_building(origin, data.footprint)
	node.queue_free()
	placed_buildings.erase(origin)
	EventBus.building_demolished.emit(data, origin)
	return true


func _scan_catalog(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		var full_path := path + "/" + file_name
		if dir.current_is_dir():
			_scan_catalog(full_path)
		elif file_name.ends_with(".tres"):
			var data := load(full_path) as BuildingData
			if data != null:
				register_building(data)
		file_name = dir.get_next()
	dir.list_dir_end()


func _instantiate_building(data: BuildingData, cell: Vector2i) -> Node2D:
	var scene: PackedScene = data.scene if data.scene != null else BUILDING_BASE_SCENE
	var instance: Node2D = scene.instantiate()
	instance.position = _terrain_layer().map_to_local(cell)
	_buildings_layer().add_child(instance)
	instance.set_data(data)
	return instance


func _terrain_layer() -> TileMapLayer:
	return get_tree().get_first_node_in_group("terrain_layer") as TileMapLayer


func _buildings_layer() -> Node2D:
	return get_tree().get_first_node_in_group("buildings_layer") as Node2D


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar lista de (building_id, cell) colocados.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: reconstruir edificios colocados a partir del save.
	pass
