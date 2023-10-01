extends Node2D

@onready var tile_map: TileMap = $'../../Island'
@export var building_prefab: PackedScene

func _ready():
	$'../EventManager'.block_clicked.connect(place_building)

func check_free_space(layer, coordinate):
	var cell = tile_map.get_cell_tile_data(layer, coordinate)
	if (cell != null):
		return false
	for b in get_children():
		if (b.layer == layer):
			for b_coord in b.coordinates:
				if (b_coord == coordinate):
					return false
	return true

func place_building(block_type, layer, coordinate, screen_coordinate, wall_click):
	if (!wall_click && block_type == 0):
		for ground_coord in [coordinate, coordinate + Vector2i(1, 0), coordinate + Vector2i(abs(coordinate.y % 2), 1), coordinate + Vector2i(abs(coordinate.y % 2), -1)]:
			var ground_cell = tile_map.get_cell_tile_data(layer, ground_coord)
			if (ground_cell == null || ground_cell.terrain != 0):
				print('Still No.')
				return
		var building_coordinates = [coordinate + Vector2i(0, -2), coordinate + Vector2i(1, -2), coordinate + Vector2i(abs(coordinate.y % 2), -1), coordinate + Vector2i(abs(coordinate.y % 2), -3)]
		for b_coord in building_coordinates:
			if (!check_free_space(layer + 1, b_coord)):
				print('Don\'t insist.')
				return
		var new_building: Building = building_prefab.instantiate()
		new_building.coordinates = building_coordinates
		new_building.layer = layer + 1
		new_building.island = tile_map
		new_building.z_index = tile_map.get_layer_z_index(layer + 1)
		new_building.position = tile_map.map_to_local(building_coordinates[0])
		add_child(new_building)
	else:
		print('No.')
