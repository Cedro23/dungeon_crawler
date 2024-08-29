class_name DungeonManager extends Node2D

const player_definition: EntityDefinition = preload("res://assets/definitions/entities/player.tres")

var player: Entity
@onready var input_handler: InputHandler = $InputHandler
@onready var map: DungeonMap = $DungeonMap
@onready var camera: Camera2D = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = Entity.new(null, Vector2i.ZERO, player_definition)
	remove_child(camera)
	player.add_child(camera)
	map.generate(player)
	map.update_fov(player.grid_position)

func _physics_process(_delta: float) -> void:
	var action: Action = input_handler.get_action(player)
	if action:
		var previous_player_position: Vector2i = player.grid_position
		action.perform()
		_handle_ais_turn()
		if player.grid_position != previous_player_position:
			map.update_fov(player.grid_position)


func _handle_ais_turn() -> void:
	for entity in map.map_data.get_actors():
		var heatlh_comp: HealthComponent = entity.get_component("Health")
		if not heatlh_comp or not heatlh_comp.is_alive():
			continue
			
		var ai: AIComponent = entity.get_component("AI")
		if ai:
			ai.get_action(entity, player).perform()
