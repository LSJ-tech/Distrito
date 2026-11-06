class_name BuildingPlacer
extends Node

## Traduce el input del jugador (mouse/cursor) en una intención de colocación
## y muestra el preview (building_ghost_preview.tscn). No es autoload: vive
## como nodo dentro de la escena de juego (main.tscn), es estado de sesión
## de interacción, no estado de la partida.

var selected_building: BuildingData


func select_building(data: BuildingData) -> void:
	selected_building = data


func cancel_selection() -> void:
	selected_building = null

# TODO Etapa 3: capturar input, convertir a celda con IsoUtils.iso_to_grid,
# mostrar/mover el preview, y llamar BuildingManager.try_place_building al confirmar.
