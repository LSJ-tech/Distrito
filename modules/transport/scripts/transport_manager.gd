extends Node

## Manager único del módulo Transporte: gestiona carreteras, conectividad y
## tráfico agregado. ConnectivityGraph y TrafficSimulator son clases
## auxiliares que posee, no autoloads propios, para no exceder el número de
## singletons globales del proyecto.

var _connectivity := ConnectivityGraph.new()
var _traffic := TrafficSimulator.new()


func try_place_road(cell: Vector2i) -> bool:
	# TODO Etapa 3: marcar la celda como carretera en GridManager, actualizar
	# autotiling visual, reconstruir _connectivity y emitir EventBus.road_placed
	# + road_network_changed.
	return false


func try_remove_road(cell: Vector2i) -> bool:
	# TODO Etapa 3: liberar la celda en GridManager, reconstruir _connectivity
	# y emitir EventBus.road_removed + road_network_changed.
	return false


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
