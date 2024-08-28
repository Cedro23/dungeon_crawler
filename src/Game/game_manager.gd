class_name GameManager
extends Node2D

@onready var player: Entity = $Player
@onready var slime: Entity = $Slime

@onready var attack_system: AttackSystem = $Systems/Attack

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if Input.is_action_just_pressed("move_up"):
		player.move(Vector2i.UP)
	elif Input.is_action_just_pressed("move_down"):
		player.move(Vector2i.DOWN)
	elif Input.is_action_just_pressed("move_left"):
		player.move(Vector2i.LEFT)
	elif Input.is_action_just_pressed("move_right"):
		player.move(Vector2i.RIGHT)
	elif Input.is_action_just_pressed("move_up_left"):
		player.move(Vector2i.UP + Vector2i.LEFT)
	elif Input.is_action_just_pressed("move_up_right"):
		player.move(Vector2i.UP + Vector2i.RIGHT)
	elif Input.is_action_just_pressed("move_down_left"):
		player.move(Vector2i.DOWN + Vector2i.LEFT)
	elif Input.is_action_just_pressed("move_down_right"):
		player.move(Vector2i.DOWN + Vector2i.RIGHT)
	elif Input.is_action_just_pressed("wait"):
		pass
	elif Input.is_action_just_pressed("pause"):
		get_tree().quit()

	elif Input.is_action_just_pressed("debug"):
		attack_system.attack(player, slime)
		attack_system.attack(slime, player)
		
