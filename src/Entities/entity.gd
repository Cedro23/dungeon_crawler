class_name Entity
extends Sprite2D

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

@export var components: Dictionary = {}
@export var is_blocking: bool = true

func _ready():
	grid_position = Grid.world_to_grid(position)
	for component in get_node("Components").get_children():
		add_component(component.name, component)

func add_component(component_name: String, component: Node):
	components[component_name] = component

func get_component(component_name: String) -> Node:
	return components.get(component_name)
