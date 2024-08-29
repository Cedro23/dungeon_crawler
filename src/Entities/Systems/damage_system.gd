class_name DamageSystem extends RefCounted

func _init():
	pass

func apply_damage(entity: Entity, amount: int) -> void:
	var healt_component = entity.get_component("Health")
	if healt_component:
		healt_component.take_damage(amount)
		print("%s's HP: %d" % [entity.entity_name, healt_component.current_health])
		if not healt_component.is_alive():
			_on_entity_dead(entity)

func _on_entity_dead(entity: Entity):
	if entity == entity.map_data.player:
		print("YOU DIED!")
		SignalBus.player_died.emit()
	else:
		print("%s died." % entity.entity_name)
	entity.entity_name = "Remains of %s" % entity.entity_name
	entity.type = Entity.EntityType.CORPSE
	entity.is_blocking = false
	entity.texture = entity.death_texture
	entity.modulate = entity.death_color
