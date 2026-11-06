extends Node

## Manager único del módulo Eventos/Misiones: dispara y resuelve eventos
## urbanos aleatorios/condicionales, y trackea objetivos. MissionManager es
## una clase auxiliar que posee. Solo escucha stats agregados de otros
## módulos vía EventBus; nadie depende de este módulo.

var _missions := MissionManager.new()


func trigger_random_event() -> void:
	# TODO: seleccionar y emitir un evento urbano aleatorio/condicional
	# (contenido real a definir en etapas posteriores, no en Etapa 1).
	pass


func get_active_missions() -> Dictionary:
	return _missions.active_missions


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar misiones activas/completadas.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: restaurar estado de misiones desde el save.
	pass
