extends Control

## Muestra estado agregado (fondos, población, etc.) leyendo managers vía
## EventBus. Nunca escribe estado de ningún manager directamente.

@onready var _population_label: Label = $PopulationLabel


func _ready() -> void:
	EventBus.population_changed.connect(_on_population_changed)
	_on_population_changed(PopulationManager.get_total_population())


func _on_population_changed(total: int) -> void:
	_population_label.text = "Población: %d" % total

# TODO Etapa 5+: conectar EventBus.funds_changed y otros stats cuando existan.
