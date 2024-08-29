class_name MoveSystem extends RefCounted

func _init():
	pass

func move(entity: Entity, move_offset: Vector2i) -> void:
	entity.grid_position += move_offset
