class_name ConnectivityGraph
extends RefCounted

## Calcula qué celdas/edificios están conectados a la red de carreteras.
## Clase auxiliar, propiedad exclusiva de TransportManager (no es autoload).
## "Conectado" = la componente de carreteras de esa celda toca el borde del
## grid (simula una salida de la ciudad; no hay marcadores de salida
## definidos todavía). Recalculo completo por BFS, disparado por evento
## (road_network_changed), nunca por frame.

## Solo contiene las celdas de carretera que SÍ están conectadas.
var _connected_roads: Dictionary = {}


func is_cell_connected(cell: Vector2i) -> bool:
	if _connected_roads.has(cell):
		return true
	for neighbor in _orthogonal_neighbors(cell):
		if _connected_roads.has(neighbor):
			return true
	return false


func rebuild() -> void:
	_connected_roads.clear()
	var visited: Dictionary = {}
	for x in GameConstants.GRID_WIDTH:
		for y in GameConstants.GRID_HEIGHT:
			var start := Vector2i(x, y)
			if visited.has(start):
				continue
			var start_data := GridManager.get_cell(start)
			if start_data == null or not start_data.has_road:
				continue
			_flood_fill_component(start, visited)


func _flood_fill_component(start: Vector2i, visited: Dictionary) -> void:
	var component: Array[Vector2i] = []
	var touches_border := false
	var queue: Array[Vector2i] = [start]
	visited[start] = true
	while not queue.is_empty():
		var current: Vector2i = queue.pop_back()
		component.append(current)
		if current.x == 0 or current.y == 0 \
			or current.x == GameConstants.GRID_WIDTH - 1 or current.y == GameConstants.GRID_HEIGHT - 1:
			touches_border = true
		for neighbor in _orthogonal_neighbors(current):
			if visited.has(neighbor):
				continue
			var neighbor_data := GridManager.get_cell(neighbor)
			if neighbor_data != null and neighbor_data.has_road:
				visited[neighbor] = true
				queue.append(neighbor)
	if touches_border:
		for cell in component:
			_connected_roads[cell] = true


func _orthogonal_neighbors(cell: Vector2i) -> Array[Vector2i]:
	return [cell + Vector2i.UP, cell + Vector2i.DOWN, cell + Vector2i.LEFT, cell + Vector2i.RIGHT]
