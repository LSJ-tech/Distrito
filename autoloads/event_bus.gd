extends Node

## Único canal de comunicación entre módulos. Las señales se declaran una por
## una y tipadas: nunca un emit(event_name: String, payload: Dictionary) genérico.
## Cada módulo solo emite las señales de su propia sección y solo escucha las
## que necesita; ningún módulo llama directamente a otro manager.

# --- Simulación ---
signal simulation_tick(tick: int)
signal simulation_paused(is_paused: bool)

# --- Construcción (Terreno + Edificios) ---
signal building_placed(data: BuildingData, cell: Vector2i)
signal building_demolished(data: BuildingData, cell: Vector2i)

# --- Transporte ---
signal road_placed(cell: Vector2i)
signal road_removed(cell: Vector2i)
signal road_network_changed()

# --- Población ---
signal population_changed(total: int)

# --- Economía ---
signal funds_changed(total: int)
signal tax_rate_changed(category: GameEnums.BuildingCategory, rate: float)

# --- Servicios y emergencias ---
signal service_coverage_changed(service_type: GameEnums.ServiceType)
signal emergency_triggered(emergency_type: GameEnums.EmergencyType, cell: Vector2i)
signal emergency_resolved(emergency_type: GameEnums.EmergencyType, cell: Vector2i)

# --- Eventos urbanos y misiones ---
signal city_event_triggered(event_id: StringName)
signal mission_completed(mission_id: StringName)

# --- Guardado ---
signal game_saved(path: String)
signal game_loaded(path: String)
