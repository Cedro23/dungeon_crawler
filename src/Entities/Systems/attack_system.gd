class_name AttackSystem extends RefCounted

var dmg_number_scene = preload("res://src/UI/damage_number.tscn")
var root: Node

var player: Entity
var _rng := RandomNumberGenerator.new()

func _init(_player: Entity):
	player = _player
	root = player.get_tree().current_scene

# Calculates the amount of damage then sends it to the damage system
func attack(attacker: Entity, target: Entity) -> void:
	var attack_component = attacker.get_component("Attack")
	var defense_component = target.get_component("Defense")
	
	var target_def = defense_component.armor if defense_component else 0
	
	for i in range(attack_component.base_nb_of_attacks):
		if target.is_alive() == false:
			return
		var is_crit = _rng.randf() <= attack_component.base_crit_chance
		var raw_dmg: int = _calc_raw_damage(attack_component, is_crit)
		var mitigated_dmg: int = _calc_mitigated_damage(raw_dmg, target_def)
		_display_damage_number(mitigated_dmg, target.position, attacker.position, 1.0, is_crit)
			
		var damage_system = DamageSystem.new(attacker)
		damage_system.apply_damage(target, mitigated_dmg)
	

func _calc_raw_damage(attack_comp: AttackComponent, is_crit: bool) -> int:
	var min_dmg: int = attack_comp.base_attack_damage.x
	var max_dmg: int = attack_comp.base_attack_damage.y
	var damage: int = _rng.randi_range(min_dmg, max_dmg)
	if is_crit:
		damage *= roundi(attack_comp.base_crit_multiplier)
	return damage

func _calc_mitigated_damage(raw_dmg: int, armor: int) -> int:
	var mitigated_dmg: int
	if armor >= 0:
		mitigated_dmg = roundi(raw_dmg * (100.0 / (100.0 + armor)))
	else:
		mitigated_dmg = roundi(raw_dmg * (2 - (100.0 / (100.0 - armor))))

	if mitigated_dmg < 0:
		mitigated_dmg = 0

	return mitigated_dmg

func _display_damage_number(amount: int, start_pos: Vector2, attacker_pos: Vector2, duration: float, is_crit: bool):
	var new_scene: Node = dmg_number_scene.instantiate()
	root.add_child(new_scene)
	var direction = start_pos - attacker_pos
	new_scene.display(amount, start_pos, direction,  duration, is_crit)
