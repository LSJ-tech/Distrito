class_name Budget
extends RefCounted

## Modela el presupuesto municipal por categoría (mantenimiento, servicios,
## etc.). Clase auxiliar, propiedad de EconomyManager.

var allocations: Dictionary = {}


func set_allocation(category: StringName, amount: int) -> void:
	allocations[category] = amount


func get_allocation(category: StringName) -> int:
	return allocations.get(category, 0)


func get_total_allocated() -> int:
	var total := 0
	for amount in allocations.values():
		total += amount
	return total
