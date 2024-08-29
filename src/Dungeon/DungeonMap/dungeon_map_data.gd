class_name DungeonMapData extends RefCounted

const tile_types = {
	"floor": preload("res://assets/definitions/tiles/floor.tres"),
	"wall": preload("res://assets/definitions/tiles/wall.tres"),
}

var width: int
var height: int
var tiles: Array[Tile]
var entities: Array[Entity]
var player: Entity

func _init(map_width: int, map_height: int, _player: Entity) -> void:
	width = map_width
	height = map_height
	player = _player
	entities = []
	_setup_tiles()

func _setup_tiles():
	tiles = []
	for y in range(height):
		for x in range(width):
			var tile_position := Vector2i(x, y)
			var tile = Tile.new(tile_position, tile_types.wall)
			tiles.append(tile)

func get_tile(grid_position: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_position)
	if tile_index == -1:
		return null
	return tiles[tile_index]

func get_tile_xy(x: int, y: int) -> Tile:
	var grid_position := Vector2i(x, y)
	return get_tile(grid_position)

func grid_to_index(grid_position: Vector2i) -> int:
	if not is_in_bounds(grid_position):
		return -1
	return grid_position.y * width + grid_position.x

func is_in_bounds(grid_position: Vector2i) -> bool:
	return (0 <= grid_position.x and grid_position.x < width and 0 <= grid_position.y and grid_position.y < height)

func get_blocking_entity_at_location(grid_position: Vector2i) -> Entity:
	for entity in entities:
		if entity.is_blocking and entity.grid_position == grid_position:
			return entity
	return null

func get_actors() -> Array[Entity]:
	var actors: Array[Entity] = []
	for entity in entities:
		if entity.is_alive():
				actors.append(entity)
	return actors

func get_actor_at_location(grid_position: Vector2i) -> Entity:
	for actors in get_actors():
		if actors.grid_position == grid_position:
			return actors
	return null
