extends Node2D

@onready var tile_map: TileMap = $'../../Island'
@export var building_prefab: PackedScene

var preview

func _ready():
	var event_manager = $'../EventManager'
	event_manager.block_clicked.connect(place_building)
	preview = building_prefab.instantiate()
	preview.coordinates = []
	preview.layer = 0
	preview.island = tile_map
	preview.get_child(0).visible = true
	add_child(preview)
	event_manager.block_hovered.connect(move_preview)

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

func get_valid_coordinates(block_type, layer, coordinate, wall_click):
	if (wall_click || block_type != 0):
		return []
	for ground_coord in [coordinate, coordinate + Vector2i(1, 0), coordinate + Vector2i(abs(coordinate.y % 2), 1), coordinate + Vector2i(abs(coordinate.y % 2), -1)]:
		var ground_cell = tile_map.get_cell_tile_data(layer, ground_coord)
		if (ground_cell == null || ground_cell.terrain != 0):
			return []
	var building_coordinates = [coordinate + Vector2i(0, -2), coordinate + Vector2i(1, -2), coordinate + Vector2i(abs(coordinate.y % 2), -1), coordinate + Vector2i(abs(coordinate.y % 2), -3)]
	for b_coord in building_coordinates:
		if (!check_free_space(layer + 1, b_coord)):
			return []
	return building_coordinates

func place_building(block_type, layer, coordinate, screen_coordinate, wall_click):
	var building_coordinates = get_valid_coordinates(block_type, layer, coordinate, wall_click)
	if (building_coordinates == []):
		return
	var new_building: Building = building_prefab.instantiate()
	new_building.coordinates = building_coordinates
	new_building.layer = layer + 1
	new_building.island = tile_map
	new_building.z_index = tile_map.get_layer_z_index(layer + 1)
	new_building.position = tile_map.map_to_local(building_coordinates[0])
	add_child(new_building)
	tile_map.set_cell(layer + 1, building_coordinates[0], 1, Vector2i(4, 3))
	# Spawn top part. Don't ask questions.
	tile_map.set_cell(tile_map.get_layers_count() - 1, building_coordinates[1], 1, Vector2i(4, 0))

func move_preview(block_type, layer, coordinate, screen_coordinate, on_wall):
	var building_coordinates = get_valid_coordinates(block_type, layer, coordinate, on_wall)
	if (building_coordinates != []):
		preview.get_child(0).material.set_shader_parameter('IsValid', true)
		preview.position = tile_map.map_to_local(building_coordinates[0])
	else:
		preview.get_child(0).material.set_shader_parameter('IsValid', false)
		preview.position = (get_global_mouse_position() if on_wall else tile_map.map_to_local(coordinate + Vector2i(0, -2)))
