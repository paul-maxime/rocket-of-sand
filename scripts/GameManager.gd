extends Node2D

@export var time_by_layer = 30
@export var rocket: Node2D
@export var rocket_states: Array[CompressedTexture2D]

var time = 0
var death_layer = 0
var rocket_progress = 0
var rocket_price = 100

@onready var water = $"../Island"
@onready var gathering_manager = $'GatheringManager'
@onready var interface_manager = $'/root/MainScene/CanvasLayer'

func _ready():
	randomize()
	$'/root/MainScene/CanvasLayer/Panel/BuyRocketButton'.pressed.connect(build_rocket)
	rocket.get_child(0).texture = null
	water.the_water_rises.connect(check_game_over)
	for i in water.get_layers_count():
		if (water.get_layer_name(i) == 'Game Over'):
			death_layer = i

func _process(deltaTime):
	time += deltaTime;
	if (time >= time_by_layer):
		time -= time_by_layer
		water.increase_water_level()
	water.update_water_offset(1 - time / time_by_layer)

func build_rocket():
	if (gathering_manager.current_sand >= rocket_price):
		var new_price = rocket_price * 10
		rocket_progress = min(rocket_progress + 1, rocket_states.size())
		interface_manager.update_rocket_price(new_price, rocket_states[min(rocket_progress, rocket_states.size() - 1)])
		rocket.get_child(0).texture = rocket_states[rocket_progress - 1]
		gathering_manager.add_sand(-rocket_price)
		rocket_price = new_price
		$UpgradeRocketSound.play()

func check_game_over(water_level):
	if (water_level == death_layer):
		rocket.visible = false
