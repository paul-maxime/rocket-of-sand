extends TileMap

var water_level = -1
var grid = Vector2i(50, 100)

# Called when the node enters the scene tree for the first time.
func _ready():
	increase_water_level()

func increase_water_level():
	if (water_level + 1 >= get_layers_count()):
		return
	water_level += 1
	for x in range(-grid.x / 2, grid.x / 2):
		for y in range(-grid.y / 2, grid.y / 2):
			var cell = get_cell_tile_data(water_level, Vector2i(x, y))
			if (cell == null):
				set_cell(water_level, Vector2i(x, y), 1, Vector2i(1, 0))

