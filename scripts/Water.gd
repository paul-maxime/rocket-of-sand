extends TileMap

var water_level = -1
var grid = Vector2i(50, 100)
var offset_max = 8
var water_material

# Called when the node enters the scene tree for the first time.
func _ready():
	water_material = tile_set.get_source(1).get_tile_data(Vector2i(1, 0), 0).material
	update_water_offset(0)
	increase_water_level()

func update_water_offset(percent):
	if (water_level < get_layers_count() - 1):
		percent = clamp(percent, 0, 1)
		water_material.set_shader_parameter('Offset', floor(percent * offset_max))

func increase_water_level():
	if (water_level + 1 >= get_layers_count()):
		return
	water_level += 1
	for x in range(-grid.x / 2, grid.x / 2):
		for y in range(-grid.y / 2, grid.y / 2):
			var cell = get_cell_tile_data(water_level, Vector2i(x, y - 2 * water_level))
			if (cell == null):
				set_cell(water_level, Vector2i(x, y - 2 * water_level), 1, Vector2i(1, 0))
			if water_level > 0 && y < grid.y / 2 - 1 && x > -grid.x / 2:
				set_cell(water_level - 1, Vector2i(x, y - 2 * (water_level - 1)), -1)

