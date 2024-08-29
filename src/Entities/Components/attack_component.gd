class_name AttackComponent extends Component

var attack_damage: int

func _init(_name: StringName, definition: AttackComponentDefinition) -> void:
	super(_name)
	attack_damage = definition.attack_damage
