extends Node

## Manager único del módulo Servicios: determina cobertura de servicios
## públicos y resuelve emergencias básicas. CoverageCalculator y
## EmergencyDispatcher son clases auxiliares que posee.

var _coverage := CoverageCalculator.new()
var _dispatcher := EmergencyDispatcher.new()

## service_type (int) -> Dictionary[Vector2i, int]. Conteo, no booleano: así
## si dos edificios del mismo servicio se superponen, demoler uno no le
## quita cobertura a las celdas que el otro todavía cubre.
var _coverage_counts: Dictionary = {}


func _ready() -> void:
	EventBus.building_placed.connect(_on_building_placed)
	EventBus.building_demolished.connect(_on_building_demolished)


func get_coverage_at(cell: Vector2i, service_type: GameEnums.ServiceType) -> bool:
	var cells: Dictionary = _coverage_counts.get(service_type, {})
	return cells.get(cell, 0) > 0


func trigger_emergency(emergency_type: GameEnums.EmergencyType, cell: Vector2i) -> void:
	EventBus.emergency_triggered.emit(emergency_type, cell)
	if _dispatcher.dispatch(emergency_type, cell):
		EventBus.emergency_resolved.emit(emergency_type, cell)


func get_save_data() -> Dictionary:
	# Sin estado propio que guardar (Etapa 8): _coverage_counts se reconstruye
	# solo cuando BuildingManager reproduce los edificios cívicos guardados
	# (cada building_placed recalcula la cobertura de ese edificio).
	return {}


func load_save_data(_data: Dictionary) -> void:
	pass


func _on_building_placed(data: BuildingData, cell: Vector2i) -> void:
	if data is CivicBuildingData:
		_apply_coverage(data, cell, 1)


func _on_building_demolished(data: BuildingData, cell: Vector2i) -> void:
	if data is CivicBuildingData:
		_apply_coverage(data, cell, -1)


func _apply_coverage(data: CivicBuildingData, origin: Vector2i, delta: int) -> void:
	var center := origin + data.footprint / 2
	var cells := _coverage.calculate_coverage(center, data.service_radius)
	var type_map: Dictionary = _coverage_counts.get(data.service_type, {})
	for cell in cells:
		var count: int = type_map.get(cell, 0) + delta
		if count <= 0:
			type_map.erase(cell)
		else:
			type_map[cell] = count
	_coverage_counts[data.service_type] = type_map
	EventBus.service_coverage_changed.emit(data.service_type)
