class_name MissionManager
extends RefCounted

## Trackea objetivos/misiones y su estado de cumplimiento. Clase auxiliar,
## propiedad de CityEventsManager.

var active_missions: Dictionary = {}


func is_complete(mission_id: StringName) -> bool:
	# TODO Etapa 2/9 (según alcance del cliente): evaluar condición de la misión
	# contra stats agregados (fondos, población, satisfacción) vía EventBus.
	return false
