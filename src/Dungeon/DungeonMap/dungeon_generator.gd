class_name DungeonGenerator extends Node

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 45

@export_category("Rooms RNG")
@export var max_rooms: int = 30
@export var min_room_size: int = 6
@export var max_room_size: int = 10

@export_category("Monsters RNG")
@export var max_monsters_per_room: int = 2

var _rng := RandomNumberGenerator.new()

const entity_types = {}

func _ready():
	_rng.randomize()

func generate(player: Character):
	var dungeon: DungeonMapData = DungeonMapData.new(map_width, map_height, player)
	dungeon.entities.append(player)

	var rooms: Array[Rect2i] = []

	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(min_room_size, max_room_size)
		var room_height: int = _rng.randi_range(min_room_size, max_room_size)

		var x: int = _rng.randi_range(0, map_width - room_width - 1)
		var y: int = _rng.randi_range(0, map_height - room_height - 1)

		var new_room := Rect2i(x, y, room_width, room_height)

		var has_intersections := false
		for room in rooms:
			if room.intersects(new_room.grow(-1)):
				has_intersections = true
				break
		if has_intersections:
			continue

		_carve_room(dungeon, new_room)

		if rooms.is_empty():
			player.grid_position = new_room.get_center()
			# player.map_data = dungeon
		else:
			_tunnel_between(dungeon, rooms.back().get_center(), new_room.get_center())

		_place_entities(dungeon, new_room)

		rooms.append(new_room)

	# dungeon.setup_pathfinding()
	return dungeon

func _carve_tile(dungeon: DungeonMapData, x: int, y: int) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types.floor)

func _carve_room(dungeon: DungeonMapData, room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			_carve_tile(dungeon, x, y)

func _tunnel_horizontal(dungeon: DungeonMapData, y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)

	for x in range(x_min, x_max + 1):
		_carve_tile(dungeon, x, y)

func _tunnel_vertical(dungeon: DungeonMapData, x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)

	for y in range(y_min, y_max + 1):
		_carve_tile(dungeon, x, y)

func _tunnel_between(dungeon: DungeonMapData, start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(dungeon, start.y, start.x, end.x)
		_tunnel_vertical(dungeon, end.x, start.y, end.y)
	else:
		_tunnel_vertical(dungeon, start.x, start.y, end.y)
		_tunnel_horizontal(dungeon, end.y, start.x, end.x)

func _place_entities(dungeon: DungeonMapData, room: Rect2i) -> void:
	var nb_monsters: int = _rng.randi_range(0, max_monsters_per_room)

	for _i in nb_monsters:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2i(x, y)

		var can_place = true
		for entity in dungeon.entities:
			if entity.grid_position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			var new_entity: Entity
			if _rng.randf() < 0.8:
				# new_entity = Entity.new(dungeon, new_entity_position, entity_types.orc)
				pass
			else:
				# new_entity = Entity.new(dungeon, new_entity_position, entity_types.troll)
				pass
			# dungeon.entities.append(new_entity)
