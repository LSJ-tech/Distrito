extends Camera2D

## Cámara 2D isométrica: pan con las flechas, zoom con la rueda del mouse,
## limitada a no salir del grid. Estado local de escena, no autoload.

const PAN_SPEED: float = 600.0
const ZOOM_STEP: float = 0.9
const MIN_ZOOM: float = 0.4
const MAX_ZOOM: float = 2.5
const LIMIT_MARGIN: int = 128

@onready var _terrain_layer: TileMapLayer = get_node("../World/TerrainLayer")


func _ready() -> void:
	_setup_limits_and_start_position()


func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		direction.x += 1.0
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1.0
	if Input.is_action_pressed("ui_down"):
		direction.y += 1.0
	if direction != Vector2.ZERO:
		position += direction.normalized() * PAN_SPEED * zoom.x * delta


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_apply_zoom(ZOOM_STEP)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_apply_zoom(1.0 / ZOOM_STEP)


func _apply_zoom(factor: float) -> void:
	var new_zoom := clampf(zoom.x * factor, MIN_ZOOM, MAX_ZOOM)
	zoom = Vector2(new_zoom, new_zoom)


func _setup_limits_and_start_position() -> void:
	var corners := [
		Vector2i(0, 0),
		Vector2i(GameConstants.GRID_WIDTH - 1, 0),
		Vector2i(0, GameConstants.GRID_HEIGHT - 1),
		Vector2i(GameConstants.GRID_WIDTH - 1, GameConstants.GRID_HEIGHT - 1),
	]
	var min_pos := _terrain_layer.map_to_local(corners[0])
	var max_pos := min_pos
	for corner in corners:
		var local_pos: Vector2 = _terrain_layer.map_to_local(corner)
		min_pos = min_pos.min(local_pos)
		max_pos = max_pos.max(local_pos)

	limit_left = int(min_pos.x) - LIMIT_MARGIN
	limit_top = int(min_pos.y) - LIMIT_MARGIN
	limit_right = int(max_pos.x) + LIMIT_MARGIN
	limit_bottom = int(max_pos.y) + LIMIT_MARGIN

	var center_cell := Vector2i(GameConstants.GRID_WIDTH / 2, GameConstants.GRID_HEIGHT / 2)
	position = _terrain_layer.map_to_local(center_cell)
