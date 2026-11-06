extends Node2D

## Pinta la representación visual del mundo a partir de GridManager (única
## fuente de verdad). Nunca escribe en GridManager, solo lee.

const GRASS_SOURCE_ID: int = 0
const ROAD_SOURCE_ID: int = 1
const TILE_ATLAS_COORDS: Vector2i = Vector2i(0, 0)

@onready var _terrain_layer: TileMapLayer = $TerrainLayer
@onready var _road_layer: TileMapLayer = $RoadLayer
@onready var _buildings_layer: Node2D = $BuildingsLayer
@onready var _overlay_layer: Node2D = $OverlayLayer


func _ready() -> void:
	# Grupos asignados por código (no en el .tscn): permiten que BuildingManager,
	# BuildingPlacer, DemolitionHandler, InfoPanel y OverlayLayer encuentren
	# estos nodos sin depender de una ruta relativa fija ni del orden de
	# _ready() entre ramas del árbol.
	_terrain_layer.add_to_group("terrain_layer")
	_buildings_layer.add_to_group("buildings_layer")
	_overlay_layer.add_to_group("overlay_layer")
	_paint_terrain()
	EventBus.road_placed.connect(_on_road_placed)
	EventBus.road_removed.connect(_on_road_removed)


func _paint_terrain() -> void:
	for x in GameConstants.GRID_WIDTH:
		for y in GameConstants.GRID_HEIGHT:
			var cell := GridManager.get_cell(Vector2i(x, y))
			if cell == null:
				continue
			# TODO Etapa futura: mapear cell.terrain_type a distintos tiles;
			# por ahora el MVP visual solo pinta pasto en todo el mapa.
			_terrain_layer.set_cell(Vector2i(x, y), GRASS_SOURCE_ID, TILE_ATLAS_COORDS)


func _on_road_placed(cell: Vector2i) -> void:
	_road_layer.set_cell(cell, ROAD_SOURCE_ID, TILE_ATLAS_COORDS)


func _on_road_removed(cell: Vector2i) -> void:
	_road_layer.erase_cell(cell)
