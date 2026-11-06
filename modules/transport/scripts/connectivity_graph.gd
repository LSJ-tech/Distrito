class_name ConnectivityGraph
extends RefCounted

## Calcula qué celdas/edificios están conectados a la red de carreteras.
## Clase auxiliar, propiedad exclusiva de TransportManager (no es autoload).

func is_cell_connected(cell: Vector2i) -> bool:
	# TODO Etapa 3: recorrer la red de carreteras desde `cell` (BFS/flood fill
	# sobre GridManager.has_road) hasta una salida de la ciudad o nodo raíz.
	return false


func rebuild() -> void:
	# TODO Etapa 3: reconstruir el grafo de conectividad tras un cambio de red.
	pass
