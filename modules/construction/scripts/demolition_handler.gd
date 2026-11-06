class_name DemolitionHandler
extends Node

## Traduce el input del jugador en modo demolición en llamadas a
## BuildingManager.try_demolish o TransportManager.try_remove_road, según
## qué haya en la celda bajo el cursor. No es autoload: estado de sesión de
## interacción, igual que BuildingPlacer.

var is_active: bool = false


func activate() -> void:
	is_active = true


func deactivate() -> void:
	is_active = false


func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var terrain := _terrain_layer()
		var cell := terrain.local_to_map(terrain.get_local_mouse_position())
		var data := GridManager.get_cell(cell)
		if data == null:
			return
		if data.building_id != &"":
			BuildingManager.try_demolish(cell)
		elif data.has_road:
			TransportManager.try_remove_road(cell)


func _terrain_layer() -> TileMapLayer:
	return get_tree().get_first_node_in_group("terrain_layer") as TileMapLayer
