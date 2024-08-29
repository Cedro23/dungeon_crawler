class_name DungeonMap extends Node

@export var fov_radius: int = 8

var map_data: DungeonMapData

@onready var tiles: Node2D = $Tiles
@onready var entities: Node2D = $Entities
@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator
# @onready var field_of_view: FieldOfView = $FieldOfView

func generate(player: Character) -> void:
	map_data = dungeon_generator.generate(player)
	_place_tiles()
	_place_entities()

func _place_tiles() -> void:
	for tile in map_data.tiles:
		tiles.add_child(tile)

func _place_entities() -> void:
	for entity in map_data.entities:
		entities.add_child(entity)
