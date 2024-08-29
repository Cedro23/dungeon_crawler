class_name IteractionSystem extends RefCounted

func _init():
	pass

func interact(actor: Character, entity: Entity) -> void:
	var interact_component = entity.get_component("Interactable")
	if interact_component:
		if interact_component.pickable:
			print("%s picks up %s" % [actor.name, entity.name])
		if interact_component.trigger:
			print("%s triggers %s" % [actor.name, entity.name])
