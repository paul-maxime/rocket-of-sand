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

func _ready():
	match type:
		'DRILL':
			$DrillLight.visible = true
		'FACTORY':
			$FactoryLight.visible = true

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
		var bolt_pos = position + Vector2(10, -30)
		var bolt = Sprite2D.new()
		bolt.position = bolt_pos
		bolt.texture = load("res://resources/bolt16.png")
		bolt.z_index = 1000
		$/root/MainScene/GameManager/BuildingManager/MessagesContainer.add_child(bolt)
		get_tree().create_tween().bind_node(bolt).tween_property(bolt, "position", bolt_pos + Vector2(0, -30), 2)
		var bolt_tween = get_tree().create_tween().bind_node(bolt)
		bolt_tween.tween_property(bolt, "modulate", Color(1, 1, 1, 0), 2)
		bolt_tween.tween_callback(bolt.queue_free)
