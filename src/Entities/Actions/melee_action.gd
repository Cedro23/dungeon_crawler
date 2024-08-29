class_name MeleeAction extends ActionWithDirection

func perform() -> void:
	var attack_system: AttackSystem = AttackSystem.new(player)

	var target: Entity = get_blocking_entity_at_destination()
	if not target:
		return

	attack_system.attack(entity, target)
