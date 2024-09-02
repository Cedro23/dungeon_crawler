class_name DamageSystem extends RefCounted

var attacker: Entity

func _init(_attacker: Entity):
	attacker = _attacker

func apply_damage(entity: Entity, amount: int) -> void:
	var healt_component = entity.get_component("Health")
	if healt_component:
		healt_component.take_damage(amount)
		if not entity.is_alive():
			if attacker == entity.map_data.player:
				_on_entity_killed_by_player(entity)
			else:
				_on_entity_death(entity)

func _on_entity_killed_by_player(entity: Entity):
	# TODO: give loop and exp to player
	process_entity_death(entity)


func _on_entity_death(entity: Entity):
	if entity == entity.map_data.player:
		SignalBus.player_died.emit()
	elif entity.visible: 
		# Entity kille by entity and visible by the player
		print("%s was killed by %s." % [entity.entity_name, attacker.entity_name])
	
	process_entity_death(entity)

func process_entity_death(entity: Entity):
	entity.entity_name = "Remains of %s" % entity.entity_name
	entity.map_data.unregister_blocking_entity(entity)
	entity.type = Entity.EntityType.CORPSE
	entity.is_blocking = false
	entity.texture = entity.death_texture
	entity.modulate = entity.death_color
