class_name Components extends Object

static func definition_to_component(definition: ComponentDefinition) -> Component:
	if definition is HealthComponentDefinition:
		return HealthComponent.new("Health", definition)
	elif definition is AttackComponentDefinition:
		return AttackComponent.new("Attack", definition)
	elif definition is DefenseComponentDefinition:
		return DefenseComponent.new("Defense", definition)
	elif definition is MoveComponentDefinition:
		return MoveComponent.new("Move")
	elif definition is AIComponentDefinition:
		return AIComponent.new("AI", definition)
		
	return null
