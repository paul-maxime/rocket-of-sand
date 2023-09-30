extends Node2D

@onready var tile_map = $'../../Island'
signal block_clicked(block_type, layer, coordinate, screen_coordinate, wall_click)
signal block_hovered(block_type, layer, coordinate, screen_coordinate, wall_click)

const CLICK_MAX_DISTANCE = 5

var previous_click_position = Vector2()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if !event.button_index == MOUSE_BUTTON_LEFT:
			return
		if !event.is_released():
			previous_click_position = event.position
			return
		if previous_click_position.distance_to(event.position) > CLICK_MAX_DISTANCE:
			return
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tile_map.local_to_map(tile_map.to_local(mouse_pos))
		var highest_layer = -1
		var highest_tile_data = null
		for l in range(tile_map.get_layers_count() - 1):
			var tile_data = tile_map.get_cell_tile_data(l, Vector2i(tile_pos.x, tile_pos.y + 2))
			if tile_data != null && l > highest_layer:
				highest_tile_data = tile_data
				highest_layer = l
		var above_tile = tile_map.get_cell_tile_data(highest_layer + 1, tile_pos)
		if above_tile == null:
			block_clicked.emit((highest_tile_data.terrain if highest_tile_data != null else -1), highest_layer, Vector2i(tile_pos.x, tile_pos.y + 2), mouse_pos, false)
		else:
			block_clicked.emit(above_tile.terrain, highest_layer + 1, tile_pos, mouse_pos, true)
	if event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tile_map.local_to_map(tile_map.to_local(mouse_pos))
		var highest_layer = -1
		var highest_tile_data = null
		for l in range(tile_map.get_layers_count() - 1):
			var tile_data = tile_map.get_cell_tile_data(l, Vector2i(tile_pos.x, tile_pos.y + 2))
			if tile_data != null && l > highest_layer:
				highest_tile_data = tile_data
				highest_layer = l
		var above_tile = tile_map.get_cell_tile_data(highest_layer + 1, tile_pos)
		if above_tile == null:
			block_hovered.emit((highest_tile_data.terrain if highest_tile_data != null else -1), highest_layer, Vector2i(tile_pos.x, tile_pos.y + 2), mouse_pos, false)
		else:
			block_hovered.emit(above_tile.terrain, highest_layer + 1, tile_pos, mouse_pos, true)