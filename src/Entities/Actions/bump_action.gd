class_name BumpAction extends ActionWithDirection

func perform() -> void:
	var dest := Vector2i(entity.grid_position + offset)

	if not entity.get_component("Move"):
		push_warning("Entity %s has no Move component." % entity.name)
		return

	if get_map_data().get_blocking_entity_at_location(dest):
		MeleeAction.new(entity, offset.x, offset.y).perform()
	else:
		MovementAction.new(entity, offset.x, offset.y).perform()
