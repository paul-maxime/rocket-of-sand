extends TileMap
class_name Water

@onready var game_manager = $'/root/MainScene/GameManager'

var water_level = -1
var grid = Vector2i(50, 100)
var offset_max = 8
var water_material: ShaderMaterial
var update_offset = true

signal the_water_rises(water_level)

# Called when the node enters the scene tree for the first time.
func _ready():
	water_material = tile_set.get_source(1).get_tile_data(Vector2i(1, 0), 0).material
	update_water_offset(0.9)
	increase_water_level()

func update_water_offset(percent):
	if (update_offset):
		percent = clamp(percent, 0, 1)
		water_material.set_shader_parameter('Offset', floor(percent * offset_max))
		if (water_level >= game_manager.game_over_layer && percent < 0.2):
			update_offset = false

func increase_water_level():
	if water_level + 1 > game_manager.game_over_layer:
		return
	water_level += 1
	the_water_rises.emit(water_level)
	for x in range(-grid.x / 2, grid.x / 2):
		for y in range(-grid.y / 2, grid.y / 2):
			var cell = get_cell_tile_data(water_level, Vector2i(x, y - 2 * water_level))
			var cell_below = get_cell_tile_data(water_level - 1, Vector2i(x, y - 2 * (water_level - 1))) if water_level > 0 else null
			var water_atlas = get_cell_atlas_coords(water_level - 1, Vector2i(x, y - 2 * (water_level - 1))) if cell_below != null and cell_below.terrain == 1 else Vector2i(randi_range(1, 3), 0)
			if cell == null:
				set_cell(water_level, Vector2i(x, y - 2 * water_level), 1, water_atlas)
			if water_level > 0 && cell_below.terrain != 0:
				set_cell(water_level - 1, Vector2i(x, y - 2 * (water_level - 1)), -1)
	if water_level > 0:
		$WaterRisesSound.play()


var mining_progress = {}

func erase_sand(layer, coordinates):
	var index = str(layer) + "," + str(coordinates.x) + "," + str(coordinates.y)
	mining_progress[index] = mining_progress.get(index) + 1 if mining_progress.has(index) else 1
	if mining_progress[index] < 8:
		var mining_progress_index = mining_progress[index] / 2
		set_cell(layer, coordinates, 1, Vector2i(mining_progress_index, 4))
		return
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if layer == water_level:
		set_cell(layer, coordinates, 1, Vector2i(randi_range(1, 3), 0))
	else:
		set_cell(layer, coordinates, -1)
