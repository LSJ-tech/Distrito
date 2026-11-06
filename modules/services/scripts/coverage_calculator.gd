class_name CoverageCalculator
extends RefCounted

## Calcula el radio/alcance de cobertura de un edificio de servicio sobre el
## grid. Clase auxiliar, propiedad de ServicesManager.

func calculate_coverage(center: Vector2i, radius: int) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for x in range(center.x - radius, center.x + radius + 1):
		for y in range(center.y - radius, center.y + radius + 1):
			var cell := Vector2i(x, y)
			if not GridManager.is_in_bounds(cell):
				continue
			if Vector2(center).distance_to(Vector2(cell)) <= radius:
				cells.append(cell)
	return cells
