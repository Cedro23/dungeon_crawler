class_name MovementAction extends ActionWithDirection

func perform() -> void:
	var move_system: MoveSystem = MoveSystem.new()
	var map_data: DungeonMapData = get_map_data()
	var dest_tile: Tile = map_data.get_tile(get_destination())
	if not dest_tile or not dest_tile.is_walkable():
		return
	if get_blocking_entity_at_destination():
		return
	
	move_system.move(entity, offset)
