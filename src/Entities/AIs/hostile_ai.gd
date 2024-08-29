class_name HostileAI extends BaseAI

var path: Array = []

func get_action(entity: Entity, target: Entity) -> Action:
	if not entity.get_component("Move"):
		push_error("Hostile AI requires Move component")
	if not entity.get_component("Attack"):
		push_error("Hostile AI requires Attack component")

	var map_data: DungeonMapData = entity.map_data
	var target_grid_position: Vector2i = target.grid_position
	var offset: Vector2i = target_grid_position - entity.grid_position
	var distance: int = max(abs(offset.x), abs(offset.y))

	if map_data.get_tile(entity.grid_position).is_in_view:
		if distance <= 1:
			return MeleeAction.new(entity, offset.x, offset.y)

		path = get_point_path_to(map_data, entity, target_grid_position)
		path.pop_front()

	if not path.is_empty():
		var destination := Vector2i(path[0])
		if map_data.get_blocking_entity_at_location(destination):
			return WaitAction.new(entity)

		path.pop_front()
		var move_offset: Vector2i = destination - entity.grid_position
		return MovementAction.new(entity, move_offset.x, move_offset.y)

	return WaitAction.new(entity)
