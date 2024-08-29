class_name DungeonManager extends Node2D

const player_definition: EntityDefinition = preload("res://assets/definitions/entities/player.tres")

var player: Character
@onready var map: DungeonMap = $DungeonMap
@onready var camera: Camera2D = $Camera2D

var attack_system: AttackSystem 

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Character.new(Vector2i.ZERO, player_definition)
	remove_child(camera)
	player.add_child(camera)
	map.generate(player)
	# map.update_fov(player.grid_position)

func _physics_process(_delta: float) -> void:
	# var action: Action = input_handler.get_action(player)
	# if action:
	# 	var previous_player_position: Vector2i = player.grid_position
	# 	action.perform()
	# 	_handle_ais_turn()
	# 	if player.grid_position != previous_player_position:
	# 		map.update_fov(player.grid_position)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var offset: Vector2i
	if Input.is_action_just_pressed("move_up"):
		offset = Vector2i.UP
	elif Input.is_action_just_pressed("move_down"):
		offset = Vector2i.DOWN
	elif Input.is_action_just_pressed("move_left"):
		offset = Vector2i.LEFT
	elif Input.is_action_just_pressed("move_right"):
		offset = Vector2i.RIGHT
	elif Input.is_action_just_pressed("move_up_left"):
		offset = Vector2i.UP + Vector2i.LEFT
	elif Input.is_action_just_pressed("move_up_right"):
		offset = Vector2i.UP + Vector2i.RIGHT
	elif Input.is_action_just_pressed("move_down_left"):
		offset = Vector2i.DOWN + Vector2i.LEFT
	elif Input.is_action_just_pressed("move_down_right"):
		offset = Vector2i.DOWN + Vector2i.RIGHT
	elif Input.is_action_just_pressed("wait"):
		pass
	elif Input.is_action_just_pressed("pause"):
		get_tree().quit()
