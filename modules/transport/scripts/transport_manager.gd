extends Node

## Manager único del módulo Transporte: gestiona carreteras, conectividad y
## tráfico agregado. ConnectivityGraph y TrafficSimulator son clases
## auxiliares que posee, no autoloads propios, para no exceder el número de
## singletons globales del proyecto.

var _connectivity := ConnectivityGraph.new()
var _traffic := TrafficSimulator.new()


func _ready() -> void:
	EventBus.road_network_changed.connect(_on_road_network_changed)
	EventBus.building_placed.connect(_on_building_changed)
	EventBus.building_demolished.connect(_on_building_changed)


func try_place_road(cell: Vector2i) -> bool:
	if not GridManager.is_road_placeable(cell):
		return false
	GridManager.set_road(cell, true)
	EventBus.road_placed.emit(cell)
	EventBus.road_network_changed.emit()
	return true


func try_remove_road(cell: Vector2i) -> bool:
	var data := GridManager.get_cell(cell)
	if data == null or not data.has_road:
		return false
	GridManager.set_road(cell, false)
	EventBus.road_removed.emit(cell)
	EventBus.road_network_changed.emit()
	return true


func is_cell_connected(cell: Vector2i) -> bool:
	return _connectivity.is_cell_connected(cell)


func get_traffic_load(cell: Vector2i) -> float:
	return _traffic.get_load(cell)


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar celdas con carretera.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: reconstruir red de carreteras y _connectivity.
	pass


func _on_road_network_changed() -> void:
	_connectivity.rebuild()
	_traffic.recalculate()


func _on_building_changed(_data: BuildingData, _cell: Vector2i) -> void:
	_traffic.recalculate()
