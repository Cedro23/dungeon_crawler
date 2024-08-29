class_name InteractableComponent extends Component

var pickable: bool = true
var trigger: bool = false

func _init(_name: StringName, definition: InteractableComponentDefinition) -> void:
	super(_name)
	pickable = definition.pickable
	trigger = definition.trigger
