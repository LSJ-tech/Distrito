class_name BuildingInstance
extends Node2D

## Escena visual única y reutilizable para cualquier edificio: se configura
## en runtime con su BuildingData en vez de existir una escena por edificio.

var data: BuildingData

@onready var _sprite: Sprite2D = $Sprite2D


func set_data(building_data: BuildingData) -> void:
	data = building_data
	if data and data.icon:
		_sprite.texture = data.icon
