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
	var roads: Array = []
	for x in GameConstants.GRID_WIDTH:
		for y in GameConstants.GRID_HEIGHT:
			var cell := Vector2i(x, y)
			var data := GridManager.get_cell(cell)
			if data != null and data.has_road:
				roads.append([x, y])
	return {"roads": roads}


func load_save_data(data: Dictionary) -> void:
	# Limpiar la red actual (misma cascada de eventos que al jugar).
	for x in GameConstants.GRID_WIDTH:
		for y in GameConstants.GRID_HEIGHT:
			var cell := Vector2i(x, y)
			var cell_data := GridManager.get_cell(cell)
			if cell_data != null and cell_data.has_road:
				try_remove_road(cell)
	# Reproducir la red guardada. int(): JSON no distingue int/float al
	# parsear, y Vector2i exige enteros.
	for entry in data.get("roads", []):
		try_place_road(Vector2i(int(entry[0]), int(entry[1])))


func _on_road_network_changed() -> void:
	_connectivity.rebuild()
	_traffic.recalculate()


func _on_building_changed(_data: BuildingData, _cell: Vector2i) -> void:
	_traffic.recalculate()
