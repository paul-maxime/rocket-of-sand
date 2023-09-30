extends Node2D

@export var game_duration = 10

var time = 0
@onready var water = $"../TileMap"

func _process(deltaTime):
	time += deltaTime;
	var layerLimit = game_duration / (water.get_layers_count() - 1)
	if (time >= layerLimit):
		time -= layerLimit
		water.increase_water_level()
	water.update_water_offset(1 - time / layerLimit)
