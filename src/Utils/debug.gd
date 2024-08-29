extends Node

@export var always_on_top: bool = false

func _ready():
	get_window().always_on_top = always_on_top
