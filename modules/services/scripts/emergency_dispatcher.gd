class_name EmergencyDispatcher
extends RefCounted

## Resuelve eventos de emergencia básicos contra la cobertura disponible.
## Consulta TransportManager.is_cell_connected para una "ruta" simplificada, sin
## pathfinding de agentes. Clase auxiliar, propiedad de ServicesManager.

func dispatch(emergency_type: GameEnums.EmergencyType, cell: Vector2i) -> bool:
	var service_type := _service_type_for(emergency_type)
	if not ServicesManager.get_coverage_at(cell, service_type):
		return false
	if not TransportManager.is_cell_connected(cell):
		return false
	return true


func _service_type_for(emergency_type: GameEnums.EmergencyType) -> GameEnums.ServiceType:
	match emergency_type:
		GameEnums.EmergencyType.FIRE:
			return GameEnums.ServiceType.FIRE
		GameEnums.EmergencyType.MEDICAL:
			return GameEnums.ServiceType.HEALTH
		GameEnums.EmergencyType.CRIME:
			return GameEnums.ServiceType.SAFETY
		_:
			return GameEnums.ServiceType.HEALTH
