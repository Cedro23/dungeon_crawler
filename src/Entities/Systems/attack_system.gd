class_name AttackSystem extends Node

# Calculates the amount of damage then sends it to the damage system
func attack(attacker: Entity, target: Entity) -> void:
	var attack_component = attacker.get_component("Attack")
	var defense_component = target.get_component("Defense")
	
	if attack_component:
		var total_damage = attack_component.attack_damage - defense_component.armor

		print("damage_system: %s attacks %s for %d" % [attacker.name, target.name, total_damage])
		
		var damage_system = get_parent().get_node("Damage")
		damage_system.apply_damage(target, total_damage)
