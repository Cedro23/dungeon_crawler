class_name AttackSystem extends RefCounted

func _init():
	pass

# Calculates the amount of damage then sends it to the damage system
func attack(attacker: Entity, target: Entity) -> void:
	var attack_component = attacker.get_component("Attack")
	var defense_component = target.get_component("Defense")

	
	var target_def = defense_component.armor if defense_component else 0

	var tot_damage: int = attack_component.attack_damage - target_def
	
	var atk_desc: String = "%s attacks %s" % [attacker.name, target.name, tot_damage]
	atk_desc += " for %s tot_damage." % tot_damage if tot_damage > 0 else " but does no tot_damage."


	print(atk_desc)
		
	var damage_system = DamageSystem.new()
	damage_system.apply_damage(target, tot_damage)
		
