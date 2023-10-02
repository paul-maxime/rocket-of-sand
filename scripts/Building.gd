extends Node2D
class_name Building

var coordinates
var type
var layer
var island
var gathering_manager

var update_timer = 0.0

var drill_ticks_speed: float = 2.0
var factory_ticks_speed: float = 5.0

func _process(deltaTime):
	update_timer += deltaTime
	match type:
		'DRILL':
			drill_update()
		'FACTORY':
			factory_update()

func drill_update():
	while update_timer > drill_ticks_speed:
		gathering_manager.increase_sand()
		update_timer -= drill_ticks_speed

func factory_update():
	while update_timer > factory_ticks_speed:
		gathering_manager.update_power(1)
		update_timer -= factory_ticks_speed
