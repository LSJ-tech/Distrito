extends Node

## Guarda/carga el estado de la partida como JSON en user://. No conoce la
## estructura interna de cada módulo: cada manager implementa el contrato
## get_save_data() -> Dictionary / load_save_data(data: Dictionary) -> void.
##
## Guardado "por receta", no por snapshot completo: la mayoría del estado
## (GridManager, cobertura de ServicesManager, conectividad/tráfico de
## TransportManager) se reconstruye solo cuando TransportManager y
## BuildingManager REPRODUCEN sus datos guardados a través de
## try_place_road/try_place_building — las mismas funciones que usa el
## jugador, que ya disparan en cascada (por EventBus) todo lo que depende
## de construir/pavimentar. Por eso GridManager y ServicesManager no tienen
## datos propios que guardar. Solo se restauran directamente los números
## que avanzan solos con el tiempo y que la reproducción no puede
## recalcular: total_population y funds.
##
## Un solo slot fijo (sin selector de partidas, no está pedido todavía).

const DEFAULT_SAVE_PATH: String = "user://savegame.json"

## Fondos "altos" temporales durante la carga, para que
## BuildingManager.try_place_building no rechace por falta de fondos al
## reproducir edificios (no estamos comprando de nuevo, solo restaurando).
## EconomyManager.load_save_data corre al final y fija el valor real.
const TEMP_FUNDS_DURING_LOAD: int = 2_000_000_000


func save_game(path: String = DEFAULT_SAVE_PATH) -> void:
	var save_data := {
		"save_version": GameConstants.SAVE_VERSION,
		"transport": TransportManager.get_save_data(),
		"construction": BuildingManager.get_save_data(),
		"population": PopulationManager.get_save_data(),
		"economy": EconomyManager.get_save_data(),
	}
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("No se pudo escribir el save en %s" % path)
		return
	file.store_string(JSON.stringify(save_data))
	file.close()
	EventBus.game_saved.emit(path)


func load_game(path: String = DEFAULT_SAVE_PATH) -> void:
	if not FileAccess.file_exists(path):
		push_error("No existe un save en %s" % path)
		return
	var file := FileAccess.open(path, FileAccess.READ)
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Save corrupto en %s" % path)
		return
	var save_data: Dictionary = parsed
	# save_version todavía no tiene migraciones (ningún formato ha cambiado
	# desde el primer save); se carga igual y se deja el número listo para
	# cuando haga falta comparar versiones.

	EconomyManager.funds = TEMP_FUNDS_DURING_LOAD
	TransportManager.load_save_data(save_data.get("transport", {}))
	BuildingManager.load_save_data(save_data.get("construction", {}))
	PopulationManager.load_save_data(save_data.get("population", {}))
	EconomyManager.load_save_data(save_data.get("economy", {}))

	EventBus.game_loaded.emit(path)
