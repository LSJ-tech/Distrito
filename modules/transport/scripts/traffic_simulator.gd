class_name TrafficSimulator
extends RefCounted

## Calcula una carga de tráfico AGREGADA por tramo de carretera (valor 0-1),
## sin pathfinding de agentes individuales. Restricción de diseño explícita
## del MVP: no modelar vehículos ni rutas por agente. Simplificación: la
## carga es la cantidad de edificios ortogonalmente adyacentes a ese tramo,
## normalizada contra una capacidad fija — no es flujo origen-destino.
## Recalculo completo por evento (road_network_changed, building_placed/
## demolished), nunca por frame.

const ROAD_CAPACITY: float = 4.0

var _loads: Dictionary = {}


func get_load(cell: Vector2i) -> float:
	return _loads.get(cell, 0.0)


func recalculate() -> void:
	_loads.clear()
	for x in GameConstants.GRID_WIDTH:
		for y in GameConstants.GRID_HEIGHT:
			var cell := Vector2i(x, y)
			var data := GridManager.get_cell(cell)
			if data == null or not data.has_road:
				continue
			_loads[cell] = clampf(_count_adjacent_buildings(cell) / ROAD_CAPACITY, 0.0, 1.0)


func _count_adjacent_buildings(cell: Vector2i) -> int:
	var count := 0
	for neighbor in [cell + Vector2i.UP, cell + Vector2i.DOWN, cell + Vector2i.LEFT, cell + Vector2i.RIGHT]:
		var data := GridManager.get_cell(neighbor)
		if data != null and data.building_id != &"":
			count += 1
	return count
