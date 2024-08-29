class_name AIComponent extends Component

enum AIType {
	BASE,
	HOSTILE,
}

var type: AIType
var ai: BaseAI

func _init(_name: StringName, definition: AIComponentDefinition) -> void:
	super(_name)
	type = definition.type
	
	if type == AIType.BASE:
		ai = BaseAI.new()
	elif type == AIType.HOSTILE:
		ai = HostileAI.new()

func get_action(entity: Entity, target: Entity) -> Action:
	var action = ai.get_action(entity, target)
	return action
