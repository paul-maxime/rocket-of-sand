extends Node2D

@export var game_duration = 370.0
@export var game_over_layer = 7
@export var rocket: Node2D
@export var rocket_states: Array[CompressedTexture2D]

var time = 0
var rocket_progress = 0
var rocket_price = 100

@onready var water = $"../Island"
@onready var gathering_manager = $'GatheringManager'
@onready var interface_manager = $'/root/MainScene/CanvasLayer'

func _ready():
	randomize()
	increase_intensity_over_time()
	$'/root/MainScene/CanvasLayer/Panel/BuyRocketButton'.pressed.connect(build_rocket)
	rocket.get_child(0).texture = null
	water.the_water_rises.connect(check_game_over)

func increase_intensity_over_time():
	var light_tween = get_tree().create_tween()
	light_tween.tween_property($/root/MainScene/DirectionalLight, "energy", 1, game_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var water_tween = get_tree().create_tween()
	water_tween.tween_method(update_waves, 2.0, 8.0, game_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func update_waves(value: float):
	water.water_material.set_shader_parameter("Speed", value)
	water.water_material.set_shader_parameter("Ampliture", value)

func _process(deltaTime):
	var time_by_layer = game_duration / game_over_layer
	time += deltaTime;
	if (time >= time_by_layer):
		time -= time_by_layer
		water.increase_water_level()
	water.update_water_offset(1 - time / time_by_layer)

func build_rocket():
	if (gathering_manager.current_sand >= rocket_price):
		var new_price = rocket_price * 5
		rocket_progress = min(rocket_progress + 1, rocket_states.size())
		interface_manager.update_rocket_price(new_price, rocket_states[min(rocket_progress, rocket_states.size() - 1)])
		rocket.get_node("Sprite").texture = rocket_states[rocket_progress - 1]
		rocket.get_node("PointLight").visible = true
		gathering_manager.add_sand(-rocket_price)
		rocket_price = new_price
		$UpgradeRocketSound.play()

func check_game_over(water_level):
	if water_level == game_over_layer:
		rocket.visible = false
