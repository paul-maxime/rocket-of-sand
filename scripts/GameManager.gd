extends Node

@export var game_duration = 10

var time = 0
@onready var water = $"../TileMap"

func _process(deltaTime):
	time += deltaTime;
	if (time >= game_duration / (water.get_layers_count() - 1)):
		time -= game_duration / (water.get_layers_count() - 1)
		water.increase_water_level()
	water.update_water_offset(time / (game_duration / (water.get_layers_count() - 1)))
