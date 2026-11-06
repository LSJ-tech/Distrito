class_name OverlayLayer
extends Node2D

## Capa visual semi-transparente sobre el mapa: cobertura de servicios o
## carga de tráfico, según el modo activo. Puro dibujo (_draw), nunca
## escribe estado de ningún manager. Redibuja al cambiar de modo y, si hay
## un modo activo, cuando algo relevante cambie — nunca por frame.

const NONE: StringName = &"none"
const COVERAGE: StringName = &"coverage"
const TRAFFIC: StringName = &"traffic"

const COVERAGE_COLOR: Color = Color(0.2, 0.9, 0.3, 0.35)
const TRAFFIC_LOW_COLOR: Color = Color(0.2, 0.9, 0.3, 0.45)
const TRAFFIC_HIGH_COLOR: Color = Color(0.9, 0.2, 0.2, 0.45)

var mode: StringName = NONE


func _ready() -> void:
	EventBus.building_placed.connect(_on_relevant_change)
	EventBus.building_demolished.connect(_on_relevant_change)
	EventBus.road_network_changed.connect(_on_relevant_change_no_args)
	EventBus.service_coverage_changed.connect(_on_coverage_changed)


func set_mode(new_mode: StringName) -> void:
	mode = new_mode if new_mode != mode else NONE
	queue_redraw()


func _on_relevant_change(_data: BuildingData, _cell: Vector2i) -> void:
	if mode != NONE:
		queue_redraw()


func _on_relevant_change_no_args() -> void:
	if mode != NONE:
		queue_redraw()


func _on_coverage_changed(_service_type: GameEnums.ServiceType) -> void:
	if mode != NONE:
		queue_redraw()


func _draw() -> void:
	if mode == NONE:
		return
	var terrain := get_tree().get_first_node_in_group("terrain_layer") as TileMapLayer
	if terrain == null:
		return
	for x in GameConstants.GRID_WIDTH:
		for y in GameConstants.GRID_HEIGHT:
			var cell := Vector2i(x, y)
			var color: Variant = _color_for_cell(cell)
			if color == null:
				continue
			_draw_tile(terrain, cell, color)


func _color_for_cell(cell: Vector2i) -> Variant:
	var data := GridManager.get_cell(cell)
	if data == null:
		return null
	if mode == COVERAGE:
		for service_type in [
			GameEnums.ServiceType.HEALTH, GameEnums.ServiceType.SAFETY,
			GameEnums.ServiceType.FIRE, GameEnums.ServiceType.EDUCATION,
		]:
			if ServicesManager.get_coverage_at(cell, service_type):
				return COVERAGE_COLOR
		return null
	if mode == TRAFFIC:
		if not data.has_road:
			return null
		var load := TransportManager.get_traffic_load(cell)
		return TRAFFIC_LOW_COLOR.lerp(TRAFFIC_HIGH_COLOR, load)
	return null


func _draw_tile(terrain: TileMapLayer, cell: Vector2i, color: Color) -> void:
	var center := terrain.map_to_local(cell)
	var half := GameConstants.CELL_SIZE_ISO / 2.0
	var points := PackedVector2Array([
		center + Vector2(0, -half.y),
		center + Vector2(half.x, 0),
		center + Vector2(0, half.y),
		center + Vector2(-half.x, 0),
	])
	draw_polygon(points, PackedColorArray([color]))
