extends Node2D

@onready var tile_map = $'../../TileMap'

func _input(event):
	if event is InputEventMouseButton:
			if event.is_pressed():
				var tile_pos = tile_map.local_to_map(get_global_mouse_position())
				print(tile_pos)
				var hl = 0
				for l in range(tile_map.get_layers_count() - 1):
					var tile_data = tile_map.get_cell_tile_data(l, Vector2i(tile_pos.x, tile_pos.y + 2))
					if tile_data != null && l > hl:
						hl = l
				tile_map.set_cell(hl, Vector2i(tile_pos.x, tile_pos.y + 2), 1, Vector2i(0, 1))
