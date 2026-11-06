class_name BuildingData
extends Resource

## Datos configurables de un tipo de edificio. Inmutable en runtime: agregar
## un edificio nuevo es crear un .tres, nunca tocar código.

@export var id: StringName
@export var display_name: String
@export var category: GameEnums.BuildingCategory
@export var footprint: Vector2i = Vector2i(1, 1)
@export var cost: int = 0
@export var maintenance_cost: int = 0
@export var requires_road_adjacency: bool = true
@export var icon: Texture2D
@export var scene: PackedScene
