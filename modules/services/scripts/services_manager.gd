extends Node

## Manager único del módulo Servicios: determina cobertura de servicios
## públicos y resuelve emergencias básicas. CoverageCalculator y
## EmergencyDispatcher son clases auxiliares que posee.

var _coverage := CoverageCalculator.new()
var _dispatcher := EmergencyDispatcher.new()


func get_coverage_at(cell: Vector2i, service_type: GameEnums.ServiceType) -> bool:
	# TODO Etapa 6: consultar cobertura calculada para `service_type` en `cell`.
	return false


func trigger_emergency(emergency_type: GameEnums.EmergencyType, cell: Vector2i) -> void:
	EventBus.emergency_triggered.emit(emergency_type, cell)
	if _dispatcher.dispatch(emergency_type, cell):
		EventBus.emergency_resolved.emit(emergency_type, cell)


func get_save_data() -> Dictionary:
	# TODO Etapa 8: serializar edificios de servicio y su cobertura calculada.
	return {}


func load_save_data(data: Dictionary) -> void:
	# TODO Etapa 8: reconstruir cobertura desde el save.
	pass

# TODO Etapa 6: conectar a EventBus.building_placed/demolished (edificios
# cívicos) y recalcular cobertura con _coverage, emitiendo
# EventBus.service_coverage_changed.
