class_name AttackComponent extends Component

var base_attack_damage: Vector2i
var base_crit_chance: float
var base_crit_multiplier: float
var base_nb_of_attacks: int

func _init(_name: StringName, definition: AttackComponentDefinition) -> void:
	super(_name)
	base_attack_damage = definition.base_attack_damage
	base_crit_chance = definition.base_crit_chance
	base_crit_multiplier = definition.base_crit_multiplier
	base_nb_of_attacks = definition.base_nb_of_attacks
