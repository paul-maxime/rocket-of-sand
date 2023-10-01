extends Node2D

@export var time_by_layer = 30

var time = 0
@onready var water = $"../Island"

func _process(deltaTime):
	time += deltaTime;
	if (time >= time_by_layer):
		time -= time_by_layer
		water.increase_water_level()
	water.update_water_offset(1 - time / time_by_layer)
