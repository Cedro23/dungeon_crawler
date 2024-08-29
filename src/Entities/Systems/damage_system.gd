class_name DamageSystem extends RefCounted

func _init():
	pass

func apply_damage(entity: Entity, amount: int) -> void:
	var healt_component = entity.get_component("Health")
	if healt_component:
		healt_component.take_damage(amount)
		print("%s's HP: %d" % [entity.name, healt_component.current_health])
		if not healt_component.is_alive():
			_on_entity_dead(entity)

func _on_entity_dead(entity: Entity):
	print("%s died." % entity.name)
	entity.name = "Broken %s" % entity.name
	if entity is Character:
		entity.name = "Remains of %s" % entity.name
	print("%s" % entity.name)
	entity.is_blocking = false
