class_name Action extends RefCounted

var entity: Entity

func _init(_entity: Entity) -> void:
	entity = _entity

func perform() -> void:
	pass

func get_map_data() -> DungeonMapData:
	return entity.map_data
