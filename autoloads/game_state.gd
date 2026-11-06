extends Node

## Estado global no específico de un módulo: pausa y velocidad de simulación.
## No contiene lógica de ningún sistema; SimulationManager es quien reacciona
## a estos valores en cada tick.

var is_paused: bool = false
var simulation_speed: float = 1.0


func pause() -> void:
	is_paused = true
	EventBus.simulation_paused.emit(true)


func resume() -> void:
	is_paused = false
	EventBus.simulation_paused.emit(false)


func set_speed(speed: float) -> void:
	simulation_speed = speed
