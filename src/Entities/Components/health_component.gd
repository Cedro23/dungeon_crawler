class_name HealthComponent extends Node

@export var max_health: int = 30
var current_health: int
@export var defense: int = 0

func _ready():
	current_health = max_health

func is_alive() -> bool:
	return current_health > 0

func take_damage(amount: int) -> void:
	current_health -= amount
