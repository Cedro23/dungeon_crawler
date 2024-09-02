class_name MoveSystem extends RefCounted

func _init():
	pass

func move(entity: Entity, move_offset: Vector2i) -> void:
	entity.map_data.unregister_blocking_entity(entity)
	entity.grid_position += move_offset
	entity.map_data.register_blocking_entity(entity)
	
