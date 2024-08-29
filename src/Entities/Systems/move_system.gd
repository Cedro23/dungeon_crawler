class_name MoveSystem extends RefCounted

func _init():
	pass

func move(entity: Entity, move_offset: Vector2i) -> void:
	if move_offset.x != 0:
		entity.flip_h = move_offset.x > 0
		
	
	entity.grid_position += move_offset
	
