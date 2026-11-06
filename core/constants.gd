class_name GameConstants
extends RefCounted

const GRID_WIDTH: int = 64
const GRID_HEIGHT: int = 64
const GRID_SIZE: Vector2i = Vector2i(GRID_WIDTH, GRID_HEIGHT)

## Tamaño de una celda en proyección isométrica, en píxeles.
const CELL_SIZE_ISO: Vector2 = Vector2(64, 32)

const SAVE_VERSION: int = 1

const STARTING_FUNDS: int = 10000

## Impuesto residencial por habitante, cobrado cada tick de simulación.
const RESIDENTIAL_TAX_PER_CAPITA: int = 2
