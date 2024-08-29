class_name Entity extends Sprite2D

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

var _definition: EntityDefinition
var entity_name: String
var is_blocking: bool

var components: Dictionary = {}

func _init(start_position: Vector2i, entity_definition: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	_definition = entity_definition
	set_entity(entity_definition)

func _add_component(component_name: String, component: Component) -> void:
	components[component_name] = component

func get_component(component_name: String) -> Component:
	return components.get(component_name)

func set_entity(entity_definition: EntityDefinition) -> void:
	entity_name = entity_definition.name
	is_blocking = entity_definition.is_blocking
	texture = entity_definition.texture
	modulate = entity_definition.color

	for comp_definition in entity_definition.components:
		var component: Component = Components.definition_to_component(comp_definition)
		_add_component(component.name, component)

func is_alive() -> bool:
	var health_component = get_component("Health")
	if health_component:
		return health_component.is_alive()
	return false
	#return get_component("Health").is_alive()
