class_name TrafficSimulator
extends RefCounted

## Calcula una carga de tráfico AGREGADA por tramo de carretera (valor 0-1),
## sin pathfinding de agentes individuales. Restricción de diseño explícita
## del MVP: no modelar vehículos ni rutas por agente.

func get_load(cell: Vector2i) -> float:
	# TODO Etapa 7: estimar carga agregada a partir de demanda de viajes
	# entre zonas (residencial/comercial/industrial) y capacidad de la red.
	return 0.0


func recalculate() -> void:
	# TODO Etapa 7: recalcular cargas, disparado por simulation_tick, no por frame.
	pass
