extends Node2D

## Pinta la representación visual del mundo a partir de GridManager (única
## fuente de verdad). Nunca escribe en GridManager, solo lee.

const GRASS_SOURCE_ID: int = 0
const GRASS_ATLAS_COORDS: Vector2i = Vector2i(0, 0)

@onready var _terrain_layer: TileMapLayer = $TerrainLayer


func _ready() -> void:
	_paint_terrain()


func _paint_terrain() -> void:
	for x in GameConstants.GRID_WIDTH:
		for y in GameConstants.GRID_HEIGHT:
			var cell := GridManager.get_cell(Vector2i(x, y))
			if cell == null:
				continue
			# TODO Etapa futura: mapear cell.terrain_type a distintos tiles;
			# por ahora el MVP visual solo pinta pasto en todo el mapa.
			_terrain_layer.set_cell(Vector2i(x, y), GRASS_SOURCE_ID, GRASS_ATLAS_COORDS)
