extends Control

## Muestra estado agregado (fondos, población, etc.) leyendo managers vía
## EventBus. Nunca escribe estado de ningún manager directamente.

@onready var _population_label: Label = $VBoxContainer/PopulationLabel
@onready var _funds_label: Label = $VBoxContainer/FundsLabel
@onready var _save_button: Button = $VBoxContainer/SaveLoadRow/SaveButton
@onready var _load_button: Button = $VBoxContainer/SaveLoadRow/LoadButton
@onready var _coverage_button: Button = $VBoxContainer/OverlayRow/CoverageButton
@onready var _traffic_button: Button = $VBoxContainer/OverlayRow/TrafficButton


func _ready() -> void:
	EventBus.population_changed.connect(_on_population_changed)
	EventBus.funds_changed.connect(_on_funds_changed)
	_on_population_changed(PopulationManager.get_total_population())
	_on_funds_changed(EconomyManager.get_funds())
	_save_button.pressed.connect(SaveManager.save_game.bind(SaveManager.DEFAULT_SAVE_PATH))
	_load_button.pressed.connect(SaveManager.load_game.bind(SaveManager.DEFAULT_SAVE_PATH))
	_coverage_button.pressed.connect(_on_overlay_button_pressed.bind(OverlayLayer.COVERAGE))
	_traffic_button.pressed.connect(_on_overlay_button_pressed.bind(OverlayLayer.TRAFFIC))


func _on_population_changed(total: int) -> void:
	_population_label.text = "Población: %d" % total


func _on_funds_changed(total: int) -> void:
	_funds_label.text = "Fondos: %d" % total


func _on_overlay_button_pressed(requested_mode: StringName) -> void:
	var overlay := get_tree().get_first_node_in_group("overlay_layer") as OverlayLayer
	if overlay == null:
		return
	overlay.set_mode(requested_mode)
	_coverage_button.button_pressed = overlay.mode == OverlayLayer.COVERAGE
	_traffic_button.button_pressed = overlay.mode == OverlayLayer.TRAFFIC
