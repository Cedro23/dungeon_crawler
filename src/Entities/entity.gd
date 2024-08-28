class_name Entity
extends Sprite2D

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

@export var components: Dictionary = {}

func _ready():
	for component in get_node("Components").get_children():
		add_component(component.name, component)

func add_component(component_name: String, component: Node):
	components[component_name] = component

func get_component(component_name: String) -> Node:
	return components.get(component_name)

func move(move_offset: Vector2i):
	grid_position += move_offset
