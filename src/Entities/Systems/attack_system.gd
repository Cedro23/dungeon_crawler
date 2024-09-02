class_name AttackSystem extends RefCounted

var player: Entity
var _rng: RandomNumberGenerator

func _init(_player: Entity):
	player = _player
	_rng = RandomNumberGenerator.new()

# Calculates the amount of damage then sends it to the damage system
func attack(attacker: Entity, target: Entity) -> void:
	var attack_component = attacker.get_component("Attack")
	var defense_component = target.get_component("Defense")
	
	var target_def = defense_component.armor if defense_component else 0
	
	for i in range(attack_component.base_nb_of_attacks):
		if target.get_component("Health").is_alive() == false:
			return
		var is_crit = _rng.randf() <= attack_component.base_crit_chance
		var tot_damage: int = _calc_damage(attack_component, is_crit) - target_def
	
		var atk_desc: String = "%s attacks %s" % [attacker.entity_name, target.entity_name]
		atk_desc += " for %s damage." % tot_damage if tot_damage > 0 else " but does no tot_damage."
		atk_desc += " (CRIT!)"  if is_crit else ""

		print(atk_desc)
			
		var damage_system = DamageSystem.new(attacker)
		damage_system.apply_damage(target, tot_damage)
	

func _calc_damage(attack_comp: AttackComponent, is_crit: bool) -> int:
	var min_dmg: int = attack_comp.base_attack_damage.x
	var max_dmg: int = attack_comp.base_attack_damage.y
	var damage: int = _rng.randi_range(min_dmg, max_dmg)
	if is_crit:
		damage *= attack_comp.base_crit_multiplier
	return damage
