class_name BuildingPlacer
extends Node

## Traduce el input del jugador (mouse/cursor) en una intención de colocación
## y muestra el preview (building_ghost_preview.tscn). No es autoload: vive
## como nodo dentro de la escena de juego (main.tscn), es estado de sesión
## de interacción, no estado de la partida.

const GHOST_PREVIEW_SCENE: PackedScene = preload("res://modules/construction/scenes/building_ghost_preview.tscn")

var selected_building: BuildingData

var _current_cell: Vector2i = Vector2i.ZERO
var _ghost: Node2D


func _ready() -> void:
	# Deferido: el nodo "buildings_layer" vive en otra rama del árbol
	# (dentro de World, instanciado como sub-escena) y no hay garantía de
	# que ya esté registrado en su grupo cuando corre este _ready().
	call_deferred("_setup_ghost")


func _setup_ghost() -> void:
	_ghost = GHOST_PREVIEW_SCENE.instantiate()
	_ghost.visible = false
	_buildings_layer().add_child(_ghost)


func select_building(data: BuildingData) -> void:
	selected_building = data


func cancel_selection() -> void:
	selected_building = null
	_ghost.visible = false


func _process(_delta: float) -> void:
	if selected_building == null:
		return
	var terrain := _terrain_layer()
	_current_cell = terrain.local_to_map(terrain.get_local_mouse_position())
	_ghost.position = terrain.map_to_local(_current_cell)
	_ghost.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if selected_building == null:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			BuildingManager.try_place_building(selected_building, _current_cell)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_selection()


func _terrain_layer() -> TileMapLayer:
	return get_tree().get_first_node_in_group("terrain_layer") as TileMapLayer


func _buildings_layer() -> Node2D:
	return get_tree().get_first_node_in_group("buildings_layer") as Node2D
