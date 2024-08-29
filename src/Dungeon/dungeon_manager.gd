class_name DungeonManager extends Node2D

@onready var player: Character = $Player
@onready var slime: Entity = $Slime

var attack_system: AttackSystem 

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_system = AttackSystem.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
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
	
	if slime.grid_position != player.grid_position + offset:
		player.move(offset)
	else:
		attack_system.attack(player, slime)
		attack_system.attack(slime, player)
