class_name EmergencyDispatcher
extends RefCounted

## Resuelve eventos de emergencia básicos contra la cobertura disponible.
## Consulta TransportManager.is_cell_connected para una "ruta" simplificada, sin
## pathfinding de agentes. Clase auxiliar, propiedad de ServicesManager.

func dispatch(emergency_type: GameEnums.EmergencyType, cell: Vector2i) -> bool:
	# TODO Etapa 7: verificar cobertura de servicio del tipo correspondiente
	# y conectividad vía TransportManager antes de resolver la emergencia.
	return false
