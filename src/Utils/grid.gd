class_name Grid extends Object

const tile_size := Vector2i(32, 32)

static func grid_to_world(grid_pos: Vector2i) -> Vector2i:
	var world_pos: Vector2i = grid_pos * tile_size
	return world_pos

static func world_to_grid(world_pos: Vector2i) -> Vector2i:
	var grid_pos: Vector2i = world_pos / tile_size
	return grid_pos

static func distance_to(from: Vector2i, to: Vector2i) -> float:
	var dx: float  = to.x - from.x
	var dy: float  = to.y - from.y

	var distance: float = sqrt(dx * dx + dy * dy)

	return distance
