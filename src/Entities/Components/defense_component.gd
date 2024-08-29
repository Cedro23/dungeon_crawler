class_name DefenseComponent extends Component

@export var armor: int

func _init(_name: StringName, definition: DefenseComponentDefinition) -> void:
	super(_name)
	armor = definition.armor
