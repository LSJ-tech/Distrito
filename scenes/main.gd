extends Node2D

## Dueño del modo de interacción activo (ninguno / construir edificio /
## construir carretera / demoler). Conecta el menú de construcción con
## BuildingPlacer, DemolitionHandler y TransportManager. No es autoload:
## es composición de la escena de juego, no estado de la partida.

enum Mode { NONE, BUILD, ROAD, DEMOLISH }

var _mode: Mode = Mode.NONE

@onready var _building_placer: BuildingPlacer = $BuildingPlacer
@onready var _demolition_handler: DemolitionHandler = $DemolitionHandler
@onready var _terrain_layer: TileMapLayer = $World/TerrainLayer
@onready var _build_menu: Control = $UI/BuildMenu


func _ready() -> void:
	_build_menu.tool_selected.connect(_on_tool_selected)


func _unhandled_input(event: InputEvent) -> void:
	if _mode != Mode.ROAD:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var cell := _terrain_layer.local_to_map(_terrain_layer.get_local_mouse_position())
		TransportManager.try_place_road(cell)


func _on_tool_selected(mode: StringName, data: BuildingData) -> void:
	_clear_mode()
	match mode:
		&"build":
			_mode = Mode.BUILD
			_building_placer.select_building(data)
		&"road":
			_mode = Mode.ROAD
		&"demolish":
			_mode = Mode.DEMOLISH
			_demolition_handler.activate()


func _clear_mode() -> void:
	_mode = Mode.NONE
	_building_placer.cancel_selection()
	_demolition_handler.deactivate()
