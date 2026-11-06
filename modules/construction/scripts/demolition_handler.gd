class_name DemolitionHandler
extends Node

## Traduce el input del jugador en modo demolición en llamadas a
## BuildingManager.try_demolish. No es autoload: estado de sesión de
## interacción, igual que BuildingPlacer.

var is_active: bool = false


func activate() -> void:
	is_active = true


func deactivate() -> void:
	is_active = false

# TODO Etapa 3: capturar input en modo demolición y llamar
# BuildingManager.try_demolish(cell) sobre la celda bajo el cursor.
