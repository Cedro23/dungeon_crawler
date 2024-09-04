class_name DamageSystem extends RefCounted

var attacker: Entity

func _init(_attacker: Entity):
	attacker = _attacker

func apply_damage(entity: Entity, amount: int) -> void:
	var healt_component = entity.get_component("Health")
	if healt_component:
		healt_component.take_damage(amount)
		_animate_damage_taken(entity, amount)
		if not entity.is_alive():
			if attacker == entity.map_data.player:
				_on_entity_killed_by_player(entity)
			else:
				_on_entity_death(entity)

func _animate_damage_taken(entity: Entity, amount: int) -> void:
	if entity.tween:
		entity.tween.kill()
	if amount > 0:
		entity.tween = entity.create_tween()
		var init_modulate = entity.modulate
		entity.tween.tween_property(entity, "modulate", Color.RED, 0.1)
		entity.tween.tween_property(entity, "modulate", init_modulate if entity.is_alive() else entity.death_color, 0.1)

func _on_entity_killed_by_player(entity: Entity) -> void:
	# TODO: give loop and exp to player
	_process_entity_death(entity)

func _on_entity_death(entity: Entity):
	if entity == entity.map_data.player:
		SignalBus.player_died.emit()
	elif entity.visible: 
		# Entity kille by entity and visible by the player
		print("%s was killed by %s." % [entity.entity_name, attacker.entity_name])
	
	_process_entity_death(entity)

func _process_entity_death(entity: Entity) -> void:
	entity.entity_name = "Remains of %s" % entity.entity_name
	entity.map_data.unregister_blocking_entity(entity)
	entity.type = Entity.EntityType.CORPSE
	entity.is_blocking = false
	entity.texture = entity.death_texture
	entity.modulate = entity.death_color
