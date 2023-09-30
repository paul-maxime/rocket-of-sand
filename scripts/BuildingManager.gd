extends Node2D

@onready var tile_map = $'../../TileMap'

func _ready():
	$'../EventManager'.block_clicked.connect(place_building)	

func place_building(block_type, layer, coordinate, screen_coordinate, wall_click):
	if (!wall_click && block_type == 0):
		tile_map.set_cell(layer, coordinate, 1, Vector2i(0, 1))
	else:
		print('No.')
