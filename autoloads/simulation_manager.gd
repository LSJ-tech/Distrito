extends Node

## Orquesta el paso de simulación (tick) a baja frecuencia, desacoplado del
## framerate. Etapas 2-7 conectan aquí los recálculos de cada manager; en
## Etapa 1 solo existe el esqueleto.

var current_tick: int = 0

@export var seconds_per_tick: float = 1.0

var _accumulator: float = 0.0


func _process(delta: float) -> void:
	if GameState.is_paused:
		return
	_accumulator += delta * GameState.simulation_speed
	if _accumulator >= seconds_per_tick:
		_accumulator = 0.0
		_advance_tick()


func _advance_tick() -> void:
	current_tick += 1
	# TODO Etapa 2+: notificar a los managers que deban recalcular estado agregado.
	EventBus.simulation_tick.emit(current_tick)
