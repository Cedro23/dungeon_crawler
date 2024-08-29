class_name BaseAI extends RefCounted

func _init() -> void:
	pass

func get_action(entity: Entity, _target: Entity) -> Action:
	return WaitAction.new(entity)


func get_point_path_to(map_data: DungeonMapData, entity: Entity, destination: Vector2i) -> PackedVector2Array:
	return map_data.pathfinder.get_point_path(entity.grid_position, destination)
