class_name IsoUtils
extends RefCounted

## Convierte una coordenada de grilla (columna, fila) a posición en pantalla
## usando proyección isométrica (diamante 2:1).
static func grid_to_iso(cell: Vector2i) -> Vector2:
	var half := GameConstants.CELL_SIZE_ISO / 2.0
	return Vector2(
		(cell.x - cell.y) * half.x,
		(cell.x + cell.y) * half.y
	)

## Convierte una posición en pantalla (isométrica) a la celda de grilla más cercana.
static func iso_to_grid(screen_pos: Vector2) -> Vector2i:
	var half := GameConstants.CELL_SIZE_ISO / 2.0
	var x := (screen_pos.x / half.x + screen_pos.y / half.y) / 2.0
	var y := (screen_pos.y / half.y - screen_pos.x / half.x) / 2.0
	return Vector2i(round(x), round(y))
