extends Node2D
class_name Building

var coordinates
var type
var layer
var island
var gathering_manager

var drill_power = 10
var drill_ticks_per_second: float = 2.0
var drill_timer = 0

func _enter_tree():
	match type:
		'FACTORY':
			gathering_manager.factory_power += 1

func _exit_tree():
	match type:
		'FACTORY':
			gathering_manager.factory_power -= 1

func _process(deltaTime):
	match type:
		'DRILL':
			drill_update(deltaTime)

func drill_update(deltaTime):
	drill_timer += deltaTime
	while drill_timer > 1 / drill_ticks_per_second:
		gathering_manager.add_sand(drill_power + gathering_manager.factory_power * gathering_manager.factory_bonus)
		drill_timer -= 1 / drill_ticks_per_second
