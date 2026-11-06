extends Control

## Muestra estado agregado (fondos, población, etc.) leyendo managers vía
## EventBus. Nunca escribe estado de ningún manager directamente.

@onready var _population_label: Label = $VBoxContainer/PopulationLabel
@onready var _funds_label: Label = $VBoxContainer/FundsLabel


func _ready() -> void:
	EventBus.population_changed.connect(_on_population_changed)
	EventBus.funds_changed.connect(_on_funds_changed)
	_on_population_changed(PopulationManager.get_total_population())
	_on_funds_changed(EconomyManager.get_funds())


func _on_population_changed(total: int) -> void:
	_population_label.text = "Población: %d" % total


func _on_funds_changed(total: int) -> void:
	_funds_label.text = "Fondos: %d" % total

# TODO Etapa 6+: conectar otros stats (cobertura de servicios, etc.) cuando existan.
