class_name HealthComponent extends Component

var max_health: int
var current_health: int

func _init(_name: StringName, definition: HealthComponentDefinition) -> void:
	super(_name)
	max_health = definition.max_health
	current_health = definition.max_health

func is_alive() -> bool:
	return current_health > 0

func take_damage(amount: int) -> void:
	current_health -= amount
