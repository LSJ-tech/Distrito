class_name CellData
extends RefCounted

## Estado runtime de una celda individual del grid (64x64 instancias).
## Es la única fuente de verdad sobre el contenido de una celda; la capa
## visual (TileMapLayer, nodos de edificio) se pinta a partir de esto y
## nunca se edita directamente desde fuera de GridManager.

var terrain_type: StringName = &"grass"
var building_id: StringName = &""
var building_origin: Vector2i = Vector2i(-1, -1)
var has_road: bool = false
var is_accessible: bool = false


func is_empty() -> bool:
	return building_id == &"" and not has_road


func has_building() -> bool:
	return building_id != &""
