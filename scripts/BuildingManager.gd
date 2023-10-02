extends Node2D

@onready var tile_map: TileMap = $'../../Island'
@onready var gathering_manager = $'../GatheringManager'
@onready var interface_manager = $'/root/MainScene/CanvasLayer'
@export var building_prefab: PackedScene

var preview
var build_mode = false
var building_type = ''

var drill_price = 10
var factory_price = 20

func _ready():
	var event_manager = $'../EventManager'
	event_manager.block_clicked.connect(place_building)
	preview = building_prefab.instantiate()
	preview.coordinates = []
	preview.layer = 0
	preview.island = tile_map

	preview.visible = false
	preview.get_node("FactoryPreview").visible = true
	preview.get_node("DrillPreview").visible = false

	$BuildingsContainer.add_child(preview)
	event_manager.block_hovered.connect(move_preview)
	$'/root/MainScene/CanvasLayer/Panel/BuyDrillButton'.pressed.connect(preview_drill)
	$'/root/MainScene/CanvasLayer/Panel/BuyFactoryButton'.pressed.connect(preview_factory)
	tile_map.the_water_rises.connect(destroy_buildings)

func check_free_space(layer, coordinate):
	var cell = tile_map.get_cell_tile_data(layer, coordinate)
	if (cell != null):
		return false
	for b in $BuildingsContainer.get_children():
		if (b.layer == layer):
			for b_coord in b.coordinates:
				if (b_coord == coordinate):
					return false
	return true

func get_valid_coordinates(block_type, layer, coordinate, wall_click):
	if (wall_click || block_type != 0):
		return []
	var has_water = false
	for ground_coord in [coordinate, coordinate + Vector2i(1, 0), coordinate + Vector2i(abs(coordinate.y % 2), 1), coordinate + Vector2i(abs(coordinate.y % 2), -1)]:
		var ground_cell = tile_map.get_cell_tile_data(layer, ground_coord)
		if (ground_cell == null || ground_cell.terrain != 0):
			return []
		if !has_water and is_next_to_water(layer, ground_coord):
			has_water = true
	if !has_water and building_type == "FACTORY":
		return []
	var building_coordinates = [coordinate + Vector2i(0, -2), coordinate + Vector2i(1, -2), coordinate + Vector2i(abs(coordinate.y % 2), -1), coordinate + Vector2i(abs(coordinate.y % 2), -3)]
	for b_coord in building_coordinates:
		if (!check_free_space(layer + 1, b_coord)):
			return []
	return building_coordinates

func is_next_to_water(layer, coordinates):
	var offset = coordinates.y & 1

	var cell = tile_map.get_cell_tile_data(layer, coordinates + Vector2i(offset, 1))
	if cell and cell.terrain == 1: return true
	cell = tile_map.get_cell_tile_data(layer, coordinates + Vector2i(-1 + offset, 1))
	if cell and cell.terrain == 1: return true
	cell = tile_map.get_cell_tile_data(layer, coordinates + Vector2i(offset, -1))
	if cell and cell.terrain == 1: return true
	cell = tile_map.get_cell_tile_data(layer, coordinates + Vector2i(-1 + offset, -1))
	if cell and cell.terrain == 1: return true

	return false

func place_building(block_type, layer, coordinate, _screen_coordinate, wall_click):
	if (!build_mode || !check_price()):
		return
	var building_coordinates = get_valid_coordinates(block_type, layer, coordinate, wall_click)
	if (building_coordinates == []):
		return
	var new_building: Building = building_prefab.instantiate()
	new_building.gathering_manager = gathering_manager
	new_building.coordinates = building_coordinates
	new_building.layer = layer + 1
	new_building.island = tile_map
	new_building.z_index = tile_map.get_layer_z_index(layer + 1)
	new_building.position = tile_map.map_to_local(building_coordinates[0])
	new_building.type = building_type
	$BuildingsContainer.add_child(new_building)

	var x_offset = 0
	if abs(building_coordinates[0].y % 2) == 1 :
		x_offset = 1

	if building_type == "FACTORY":
		$PlaceFactorySound.play()

		tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x, building_coordinates[0].y), 1, Vector2i(0, 3))
		tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1), 1, Vector2i(1, 2))
		tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y), 1, Vector2i(1, 3))

		tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 2), 1, Vector2i(4, 7))
		tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 2), 1, Vector2i(5, 6))
		tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 2), 1, Vector2i(5, 7))

		tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 4), 1, Vector2i(4, 5))
		tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 4), 1, Vector2i(5, 4))
		tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 4), 1, Vector2i(5, 5))

		tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 6), 1, Vector2i(4, 3))
		tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 6), 1, Vector2i(5, 2))
		tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 6), 1, Vector2i(5, 3))

		tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 8), 1, Vector2i(4, 1))
		tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 8), 1, Vector2i(5, 0))
		tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 8), 1, Vector2i(5, 1))

		tile_map.set_cell(layer + 6, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 12), 1, Vector2i(4, 0))

		preview.get_child(0).material.set_shader_parameter('IsValid', false)
	elif building_type == "DRILL":
		$PlaceDrillSound.play()

		tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x, building_coordinates[0].y), 1, Vector2i(6, 9))
		tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1), 1, Vector2i(6, 8))
		tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y), 1, Vector2i(10, 9))

		tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 2), 1, Vector2i(6, 7))
		tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 2), 1, Vector2i(6, 6))
		tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 2), 1, Vector2i(10, 7))

		tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 4), 1, Vector2i(6, 5))
		tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 4), 1, Vector2i(6, 4))
		tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 4), 1, Vector2i(10, 5))

		tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 6), 1, Vector2i(6, 3))
		tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 6), 1, Vector2i(6, 2))
		tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 6), 1, Vector2i(10, 3))

		tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 8), 1, Vector2i(6, 1))
		tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 8), 1, Vector2i(6, 0))
		tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 8), 1, Vector2i(10, 1))
		tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 12), 1, Vector2i(10, 0))
	update_price()

func check_price():
	match building_type:
		'FACTORY':
			return gathering_manager.current_sand >= factory_price
		'DRILL':
			return gathering_manager.current_sand >= drill_price
	return false

func update_price():
	match building_type:
		'FACTORY':
			var new_price = floor(factory_price * 1.5)
			interface_manager.update_factory_price(new_price)
			gathering_manager.add_sand(-factory_price)
			factory_price = new_price
		'DRILL':
			var new_price = floor(drill_price * 1.2)
			interface_manager.update_drill_price(new_price)
			gathering_manager.add_sand(-drill_price)
			drill_price = new_price

func move_preview(block_type, layer, coordinate, _screen_coordinate, on_wall):
	var building_coordinates = get_valid_coordinates(block_type, layer, coordinate, on_wall)
	if (building_coordinates != [] && check_price()):
		preview.get_child(0).material.set_shader_parameter('IsValid', true)
		preview.position = tile_map.map_to_local(building_coordinates[0])
	else:
		preview.get_child(0).material.set_shader_parameter('IsValid', false)
		preview.position = (get_global_mouse_position() if on_wall else tile_map.map_to_local(coordinate + Vector2i(0, -2)))

func set_build_mode(type):
	var new_build_mode = building_type != type || !build_mode
	building_type = type
	build_mode = new_build_mode
	preview.visible = new_build_mode

func _input(event):
	if build_mode && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
		build_mode = false
		preview.visible = false

func preview_drill():
	set_build_mode('DRILL')
	preview.get_node("FactoryPreview").visible = false
	preview.get_node("DrillPreview").visible = true

func preview_factory():
	set_build_mode('FACTORY')
	preview.get_node("FactoryPreview").visible = true
	preview.get_node("DrillPreview").visible = false

func destroy_buildings(water_level):
	for b in $BuildingsContainer.get_children():
		if b.layer == water_level && b.coordinates != []:
			var layer = b.layer - 1
			var building_coordinates = b.coordinates
			var x_offset = 0
			if abs(building_coordinates[0].y % 2) == 1 :
				x_offset = 1

			tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x, building_coordinates[0].y), -1)
			tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1), -1)
			tile_map.set_cell(layer + 1, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y), -1)

			tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 2), -1)
			tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 2), -1)
			tile_map.set_cell(layer + 2, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 2), -1)

			tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 4), -1)
			tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 4), -1)
			tile_map.set_cell(layer + 3, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 4), -1)

			tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 6), -1)
			tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 6), -1)
			tile_map.set_cell(layer + 4, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 6), -1)

			tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x, building_coordinates[0].y - 8), -1)
			tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 8), -1)
			tile_map.set_cell(layer + 5, Vector2i(building_coordinates[0].x + 1, building_coordinates[0].y - 8), -1)

			tile_map.set_cell(layer + 6, Vector2i(building_coordinates[0].x + x_offset, building_coordinates[0].y + 1 - 12), -1)

			$BuildingsContainer.remove_child(b)
