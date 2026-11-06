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
	# TODO Etapa 3: validar footprint completo (todas las celdas que ocuparía).
	return false


func place_building_ref(cell: Vector2i, building_id: StringName) -> void:
	# TODO Etapa 3: marcar todas las celdas del footprint con building_id.
	pass


func clear_cell(cell: Vector2i) -> void:
	# TODO Etapa 3: limpiar building_id/has_road de la celda.
	pass


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar terrain_type/building_id/has_road por celda.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: reconstruir cells a partir de los datos guardados.
	pass
