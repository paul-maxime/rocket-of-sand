extends TileMap

var water_level = -1
var grid = Vector2i(50, 100)
var offset_max = 4
var current_offset = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_water_offset(1)
	increase_water_level()

func update_water_offset(percent):
	var new_offset = clamp(floor(percent * offset_max), 0, offset_max)
	if (new_offset != current_offset):
		current_offset = new_offset
		var tile = tile_set.get_source(1).get_tile_data(Vector2i(1, 0), 0)
		tile.set_texture_origin(Vector2i(0, current_offset))

func increase_water_level():
	if (water_level + 1 >= get_layers_count()):
		return
	water_level += 1
	for x in range(-grid.x / 2, grid.x / 2):
		for y in range(-grid.y / 2, grid.y / 2):
			var cell = get_cell_tile_data(water_level, Vector2i(x, y - 2 * water_level))
			if (cell == null):
				set_cell(water_level, Vector2i(x, y - 2 * water_level), 1, Vector2i(1, 0))
			if y < grid.y / 2 - 1:
				set_cell(water_level - 1, Vector2i(x, y - 2 * (water_level - 1)), -1)

