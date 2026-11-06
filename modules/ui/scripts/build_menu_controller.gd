extends Control

## Muestra el catálogo de BuildingManager más las herramientas de carretera
## y demolición. No decide el modo de interacción: solo emite la intención
## del jugador; quien la aplica es main.gd.

signal tool_selected(mode: StringName, data: BuildingData)

@onready var _button_list: VBoxContainer = $VBoxContainer


func _ready() -> void:
	for data in BuildingManager.get_catalog():
		_add_button(data.display_name, &"build", data)
	_add_button("Carretera", &"road", null)
	_add_button("Demoler", &"demolish", null)


func _add_button(label: String, mode: StringName, data: BuildingData) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(func(): tool_selected.emit(mode, data))
	_button_list.add_child(button)
