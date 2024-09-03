class_name DungeonGenerator extends Node

@export_category("Map Dimensions")
@export var map_width: int = 81
@export var map_height: int = 45

@export_category("Rooms RNG")
@export var nb_room_tries: int = 200
@export var extra_connector_chance: int = 5
@export var room_extra_size: int = 0
@export var winding_percent: int = 0


@export_category("Monsters RNG")
@export var max_monsters_per_room: int = 2

var _dungeon: DungeonMapData
var _rooms: Array[Rect2i] = []
var _regions: Array = []
var _current_region: int = -1
var _bounds: Rect2i
var _rng := RandomNumberGenerator.new()

const entity_types = {
	"slime": preload("res://assets/definitions/entities/monsters/slime.tres"),
	"goblin": preload("res://assets/definitions/entities/monsters/goblin.tres"),
}

func _ready():
	_rng.randomize()
	_bounds = Rect2i(0, 0, map_width, map_height).grow(-1)

func generate(player: Entity):
	print("Started dungeon generation.")
	if map_width % 2 == 0 or map_height % 2 == 0:
		push_error("The stage must be odd-sized.")

	_dungeon = DungeonMapData.new(map_width, map_height, player)
	_dungeon.entities.append(player)

	_regions.resize(map_width)
	for i in range(map_width):
		_regions[i] = []
		_regions[i].resize(map_height)

	_add_rooms()
	print("%d rooms created." % len(_rooms))

	# Fill in all of the empty space with mazes.
	for x in range(1, _bounds.size.x + 1, 2):
		for y in range(1, _bounds.size.y + 1, 2):
			var pos = Vector2i(x, y)
			if _dungeon.get_tile_xy(x, y).type != TileTypes.TYPES.WALL:
				continue
			_grow_maze(pos)
	print("Mazes grown.")

	_connect_regions()
	# _remove_dead_ends()

	# Select starting room for player
	# _rooms[_rng.randi() % len(_rooms)].get_center()
	player.grid_position = Vector2i(map_width / 2, map_height / 2)
	player.map_data = _dungeon


	_dungeon.setup_pathfinding()
	print("Finished dungeon generation.")
	return _dungeon


func _grow_maze(start: Vector2i) -> void:
	var cells = []
	var last_direction = null

	_start_region()
	_carve(start)

	cells.append(start)
	while not cells.is_empty():
		var cell = cells.back()

		# See which adjacent cells are open.
		var unmade_cells = []

		for direction in Direction.CARDINAL.values():
			if _can_carve(cell, direction):
				unmade_cells.append(direction)

		if not unmade_cells.is_empty():
			# Based on how "windy" passages are, try to prefer carving in the
			# same direction.
			var direction
			if unmade_cells.has(last_direction) and _rng.randi_range(0, 100) > winding_percent:
				direction = last_direction
			else:
				direction = unmade_cells[randi() % len(unmade_cells)]

			_carve(cell + direction)
			_carve(cell + direction * 2)

			cells.append(cell + direction * 2)
			last_direction = direction
		else:
			# No adjacent uncarved cells.
			cells.pop_back()

			# This path has ended.
			last_direction = null

func _set_tile(pos: Vector2i, tile_type: TileTypes.TYPES) -> void:
	var tile: Tile = _dungeon.get_tile(pos)
	tile.set_tile_type(_dungeon.tile_types.get(tile_type))

func _connect_regions() -> void:
	# Find all the tiles that can connect 2 or more regions.
	var connector_regions: Dictionary = {} # <Vector2i, UniqueArray[int]>
	for y in _bounds.size.y:
		for x in _bounds.size.x:
			var pos = Vector2i(x, y)
			if _dungeon.get_tile_xy(x, y).type != TileTypes.TYPES.WALL:
				continue

			var regions: Array[int] = [] # UniqueArray[int]
			for dir in Direction.CARDINAL.values():
				var dest = pos + dir
				var region = _regions[dest.x][dest.y]
				if region != null:
					regions.append(region)

			if len(regions) < 2:
				continue
			
			connector_regions[pos] = regions

	var connectors: Array = connector_regions.keys() # PackedVector2Array ?

	# Keep track of which regions have been merged.
	# This maps an original region indew to the one it has been merged to.
	var merged: Dictionary = {} # Dictionary<int, int>
	var open_regions: Array[int] = [] # UniqueArray[int]
	
	for i in range(_current_region + 1):
		merged[i] = i
		open_regions.append(i)

	while len(open_regions) > 1:
		# Vector2i chosen randomly in connectors
		var connector = connectors[_rng.randi() % len(connectors)]

		# Carve the connection
		_add_junction(connector)

		# Merge the connected regions. 
		# We'll pick one region and map all of the other regions to its index.
		var merged_regions = []
		for region in connector_regions[connector]:
			merged_regions.append(merged[region])
		var dest = merged_regions.pop_front()
		var sources = merged_regions

		# Merge all of the affected regions. We have to look at *all* of the
		# regions because other regions may have previously been merged with
		# some of the ones we're merging now.
		for i in range(_current_region + 1):
			if sources.has(merged[i]):
				merged[i] = dest 

		# The sources are no longer in use.
		for source in sources:
			open_regions.erase(source)

		# Prune the connectors based on the following rules:
		var new_connectors: Array[Vector2i] = []
		for con in connectors:
			# Don't allow connectors right next to each other.
			if Grid.distance_to(con, connector) > 2:
				new_connectors.append(con)
				continue
			
			# If the connector no longer connects different regions, remove it.
			var regions = []
			for region in ArrayUtils.array_unique(connector_regions[con]):
				regions.append(merged[region])
			
			if len(regions) > 1:
				new_connectors.append(con)
				continue

			# This connector isn't needed, but connect it occasionally
			# so that the dungeon isn't singly connected.
			if _rng.randi_range(0, 100) < extra_connector_chance:
				_add_junction(con)

		connectors = new_connectors
	
	print("Regions connected.")


func _add_junction(pos: Vector2i) -> void:
	_carve(pos)
	# if (rng.oneIn(4)) {
	# 	setTile(pos, rng.oneIn(3) ? Tiles.openDoor : Tiles.floor);
	# } else {
	# 	setTile(pos, Tiles.closedDoor);
	# }

func _remove_dead_ends() -> void:
	var done: bool = false

	var count: int = 0

	while not done:
		done = true
	
		for y in _bounds.size.y:
			for x in _bounds.size.x:
				var pos := Vector2i(x, y)
				if _dungeon.get_tile_xy(pos.x, pos.y).type == TileTypes.TYPES.WALL:
					continue
				
				# If it only has one exit, it's a dead end.
				var exits: int = 0
				for dir in Direction.CARDINAL.values():
					var dest = pos + dir
					if _dungeon.get_tile_xy(dest.x, dest.y).type != TileTypes.TYPES.WALL:
						exits += 1
				if exits != 1: 
					continue
				else:
					count += 1

	
				done = false;
				_carve(pos, TileTypes.TYPES.WALL);

	print("%d cells removed." % count)

func _place_entities(room: Rect2i) -> void:
	var nb_monsters: int = _rng.randi_range(0, max_monsters_per_room)

	for _i in nb_monsters:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2i(x, y)

		var can_place = true
		for entity in _dungeon.entities:
			if entity.grid_position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			var new_entity: Entity
			if _rng.randf() < 0.8:
				new_entity = Entity.new(_dungeon, new_entity_position, entity_types.slime)
				pass
			else:
				new_entity = Entity.new(_dungeon, new_entity_position, entity_types.goblin)
				pass
			_dungeon.entities.append(new_entity)

func _add_rooms() -> void:
	for i in range(nb_room_tries):
		var size = _rng.randi_range(1, 3 + room_extra_size) * 2 + 1
		# var rectangularity = _rng.randi_range(1, int(float(size) / 3))
		var width = size
		var height = size
		# if _rng.randf() < 0.5:
		# 	width += rectangularity
		# else:
		# 	height += rectangularity
		
		var x = _rng.randi_range(0, floori(float(_bounds.size.x - width) / 2)) * 2 + 1
		var y = _rng.randi_range(0, floori(float(_bounds.size.y - height) / 2)) * 2 + 1

		var room: Rect2i = Rect2i(x, y, width, height);
		
		var overlaps: bool = false
		for other in _rooms:
			if room.intersects(other):
				overlaps = true
				break
		if overlaps:
			continue 
		
		_rooms.append(room)

		_start_region()

		_carve_room(room)
	
func _start_region() -> void:
	_current_region += 1

func _can_carve(pos: Vector2i, direction: Vector2i) -> bool:
	# Must end in bounds.
	if not _bounds.has_point(pos + direction):
		return false

	# Destination must not be open.
	var dest = pos + direction * 2
	return _dungeon.get_tile_xy(dest.x, dest.y).type == TileTypes.TYPES.WALL;

func _carve(pos: Vector2i, type: TileTypes.TYPES = TileTypes.TYPES.FLOOR) -> void:
	_set_tile(pos, type);
	_regions[pos.x][pos.y] = _current_region;

func _carve_room(room: Rect2i) -> void:
	var inner: Rect2i = room
	for x in range(inner.position.x, inner.end.x):
		for y in range(inner.position.y, inner.end.y):
			_carve(Vector2i(x,y))
