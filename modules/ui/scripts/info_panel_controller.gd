extends Control

## Muestra información de la celda bajo el mouse, leyendo GridManager/
## BuildingManager/TransportManager/ServicesManager. Solo lectura.
##
## No cachea TerrainLayer en @onready: ese nodo vive en otra rama del árbol
## (dentro de World, sub-escena) y el orden de _ready() entre ramas no está
## garantizado (mismo motivo que BuildingPlacer en Etapa 3). Se busca por
## grupo en cada _process(), que ya corre después de que todo el árbol esté listo.

const SERVICE_NAMES: Dictionary = {
	GameEnums.ServiceType.HEALTH: "Salud",
	GameEnums.ServiceType.SAFETY: "Seguridad",
	GameEnums.ServiceType.FIRE: "Incendios",
	GameEnums.ServiceType.EDUCATION: "Educación",
}

@onready var _title_label: Label = $VBoxContainer/TitleLabel
@onready var _coverage_label: Label = $VBoxContainer/CoverageLabel

var _last_cell: Vector2i = Vector2i(-999, -999)


func _process(_delta: float) -> void:
	var terrain := get_tree().get_first_node_in_group("terrain_layer") as TileMapLayer
	if terrain == null:
		return
	var cell := terrain.local_to_map(terrain.get_local_mouse_position())
	if cell == _last_cell:
		return
	_last_cell = cell
	_update_for_cell(cell)


func _update_for_cell(cell: Vector2i) -> void:
	var data := GridManager.get_cell(cell)
	if data == null:
		_title_label.text = "Fuera del mapa"
		_coverage_label.text = ""
		return

	if data.building_id != &"":
		var building_data := BuildingManager.get_building_data(data.building_id)
		_title_label.text = building_data.display_name if building_data != null else String(data.building_id)
	elif data.has_road:
		var load_percent := roundi(TransportManager.get_traffic_load(cell) * 100.0)
		_title_label.text = "Carretera (tráfico %d%%)" % load_percent
	else:
		_title_label.text = "Vacío"

	var covered: Array[String] = []
	for service_type in SERVICE_NAMES:
		if ServicesManager.get_coverage_at(cell, service_type):
			covered.append(SERVICE_NAMES[service_type])
	_coverage_label.text = "Cobertura: %s" % ", ".join(covered) if not covered.is_empty() else "Sin cobertura"
