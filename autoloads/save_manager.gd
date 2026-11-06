extends Node

## Guarda/carga el estado de la partida. No conoce la estructura interna de
## cada módulo: cada manager implementa el contrato get_save_data() -> Dictionary
## y load_save_data(data: Dictionary) -> void. Los edificios se guardan por
## `id` de BuildingData + estado runtime, nunca el Resource completo, para no
## romper saves viejos si BuildingData cambia de forma más adelante.

const SAVE_VERSION: int = GameConstants.SAVE_VERSION

## Managers que implementan el contrato de guardado, en el orden en que se
## registran sus datos. Se completa a medida que cada manager esté listo
## (Etapas 2-7); todavía no hay managers reales que serializar.
var _save_participants: Array[Node] = []


func register_participant(manager: Node) -> void:
	_save_participants.append(manager)


func save_game(path: String) -> void:
	# TODO Etapa 8: recolectar get_save_data() de cada manager registrado,
	# envolver en { "save_version": SAVE_VERSION, "modules": {...} } y escribir a disco.
	EventBus.game_saved.emit(path)


func load_game(path: String) -> void:
	# TODO Etapa 8: leer el archivo, validar save_version (migrar si difiere),
	# y repartir cada sección a su manager vía load_save_data().
	EventBus.game_loaded.emit(path)
