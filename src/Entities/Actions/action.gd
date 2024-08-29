class_name Action extends RefCounted

var entity: Entity
var player: Entity

func _init(_entity: Entity) -> void:
	entity = _entity
	player = entity.map_data.player

func perform() -> void:
	pass

func get_map_data() -> DungeonMapData:
	return entity.map_data
