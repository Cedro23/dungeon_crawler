class_name Entity extends Sprite2D

enum EntityType {
	CORPSE,
	INTERACTABLE,
	OBSTACLE,
	ITEM,
	ACTOR,
	}

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

var type: EntityType:
	set(value):
		type = value
		z_index = type

var _definition: EntityDefinition
var entity_name: String
var is_blocking: bool

var death_texture: AtlasTexture
var death_color: Color

var map_data: DungeonMapData

var components: Dictionary = {}

var tween: Tween

func _init(_map_data: DungeonMapData, start_position: Vector2i, entity_definition: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	map_data = _map_data
	set_entity(entity_definition)

func _add_component(component_name: String, component: Component) -> void:
	components[component_name] = component

func get_component(component_name: String) -> Component:
	return components.get(component_name)

func set_entity(entity_definition: EntityDefinition) -> void:
	_definition = entity_definition

	type = _definition.type
	entity_name = _definition.name
	is_blocking = _definition.is_blocking
	texture = _definition.texture
	modulate = _definition.color
	death_texture = _definition.death_texture
	death_color = _definition.death_color

	for comp_definition in entity_definition.components:
		var component: Component = Components.definition_to_component(comp_definition)
		_add_component(component.name, component)

func is_alive() -> bool:
	var health_component = get_component("Health")
	if health_component:
		return health_component.is_alive()
	return false
	#return get_component("Health").is_alive()
