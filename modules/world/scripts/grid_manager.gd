extends Node

## Única fuente de verdad del estado de las GRID_WIDTH x GRID_HEIGHT celdas.
## Construcción, Transporte y Servicios consultan este manager; nadie escribe
## en CellData directamente desde fuera de aquí. Array plano (no Dictionary):
## la grilla es fija y densa, un índice x*alto+y evita el costo de hashing.

var cells: Array[CellData] = []


func _ready() -> void:
	_initialize_grid()


func _initialize_grid() -> void:
	cells.resize(GameConstants.GRID_WIDTH * GameConstants.GRID_HEIGHT)
	for i in cells.size():
		cells[i] = CellData.new()


func _index_of(cell: Vector2i) -> int:
	return cell.x * GameConstants.GRID_HEIGHT + cell.y


func is_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 \
		and cell.x < GameConstants.GRID_WIDTH and cell.y < GameConstants.GRID_HEIGHT


func get_cell(cell: Vector2i) -> CellData:
	if not is_in_bounds(cell):
		return null
	return cells[_index_of(cell)]


func is_buildable(cell: Vector2i, footprint: Vector2i) -> bool:
	for dx in footprint.x:
		for dy in footprint.y:
			var target := Vector2i(cell.x + dx, cell.y + dy)
			var data := get_cell(target)
			if data == null or not data.is_empty():
				return false
	return true


func is_road_placeable(cell: Vector2i) -> bool:
	var data := get_cell(cell)
	return data != null and data.building_id == &"" and not data.has_road


func is_adjacent_to_road(cell: Vector2i, footprint: Vector2i) -> bool:
	for x in range(cell.x - 1, cell.x + footprint.x + 1):
		for y in range(cell.y - 1, cell.y + footprint.y + 1):
			var inside_footprint := x >= cell.x and x < cell.x + footprint.x \
				and y >= cell.y and y < cell.y + footprint.y
			if inside_footprint:
				continue
			var data := get_cell(Vector2i(x, y))
			if data != null and data.has_road:
				return true
	return false


func place_building_ref(cell: Vector2i, building_id: StringName, footprint: Vector2i) -> void:
	for dx in footprint.x:
		for dy in footprint.y:
			var data := get_cell(Vector2i(cell.x + dx, cell.y + dy))
			data.building_id = building_id
			data.building_origin = cell


func clear_building(origin: Vector2i, footprint: Vector2i) -> void:
	for dx in footprint.x:
		for dy in footprint.y:
			var data := get_cell(Vector2i(origin.x + dx, origin.y + dy))
			if data == null:
				continue
			data.building_id = &""
			data.building_origin = Vector2i(-1, -1)


func set_road(cell: Vector2i, value: bool) -> void:
	var data := get_cell(cell)
	if data != null:
		data.has_road = value


func get_save_data() -> Dictionary:
	# Sin estado propio que guardar (Etapa 8): building_id/has_road se
	# reconstruyen solos cuando TransportManager/BuildingManager reproducen
	# sus propios datos guardados a través de try_place_road/try_place_building.
	return {}


func load_save_data(_data: Dictionary) -> void:
	pass
