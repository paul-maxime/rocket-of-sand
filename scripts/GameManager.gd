extends Node2D

@export var game_duration = 370.0
@export var game_over_layer = 7
@export var rocket: Node2D
@export var rocket_states: Array[CompressedTexture2D]

var time = 0
var rocket_progress = 0
var rocket_price = 100

enum states {WAITING, PLAYING, WIN, DEAD}
var game_state = states.WAITING
var restart_with_left_click = false

@onready var water = $"../Island"
@onready var gathering_manager = $'GatheringManager'
@onready var interface_layer = $'/root/MainScene/CanvasLayer'

func _ready():
	randomize()
	$'/root/MainScene/CanvasLayer/Panel/BuyRocketButton'.pressed.connect(build_rocket)
	rocket.get_child(0).texture = null
	water.the_water_rises.connect(check_game_over)

func start_playing():
	if game_state == states.WAITING:
		game_state = states.PLAYING
		increase_intensity_over_time()
		$/root/MainScene/MusicPlayer.play()

func increase_intensity_over_time():
	var light_tween = get_tree().create_tween()
	light_tween.tween_property($/root/MainScene/DirectionalLight, "energy", 1, game_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var water_tween = get_tree().create_tween()
	water_tween.tween_method(update_waves, 2.0, 8.0, game_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func update_waves(value: float):
	water.water_material.set_shader_parameter("Speed", value)
	water.water_material.set_shader_parameter("Ampliture", value)

func _process(deltaTime):
	if game_state == states.WAITING:
		return
	var time_by_layer = game_duration / game_over_layer
	time += deltaTime;
	if (time >= time_by_layer):
		time -= time_by_layer
		water.increase_water_level()
	water.update_water_offset(1 - time / time_by_layer)

func build_rocket():
	if (gathering_manager.current_sand >= rocket_price):
		var new_price = rocket_price * 5
		rocket_progress += 1
		interface_layer.update_rocket_price(new_price, rocket_states[min(rocket_progress, rocket_states.size() - 1)])
		rocket.get_node("Sprite").texture = rocket_states[rocket_progress - 1]
		rocket.get_node("PointLight").visible = true
		rocket.get_node("PointLight").texture_scale = 1.0 + ((rocket_progress - 1.0) / 5.0)
		rocket.get_node("PointLight").energy = 0.5 + (rocket_progress - 1.0) / 20.0
		gathering_manager.add_sand(-rocket_price)
		rocket_price = new_price
		$UpgradeRocketSound.play()
		if rocket_progress >= len(rocket_states) - 1:
			win_the_game()

func win_the_game():
	game_state = states.WIN
	interface_layer.get_node("Panel").visible = false
	rocket.z_index = 50
	$/root/MainScene/Camera.start_following_rocket(rocket)
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	rocket.get_node("Sprite").texture = rocket_states[rocket_progress]
	rocket.position.y += 5
	tween.tween_property(rocket, "position", Vector2(rocket.position.x, rocket.position.y - 10000), 10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	$/root/MainScene/MusicPlayer.fadeout(10.0)
	await get_tree().create_timer(5).timeout
	var victory_panel = $/root/MainScene/CanvasLayer/Victory
	victory_panel.visible = true
	var victory_tween = get_tree().create_tween()
	victory_tween.tween_property(victory_panel, "modulate", Color(1, 1, 1, 1), 2).set_trans(Tween.TRANS_SINE)
	victory_tween.tween_callback(game_over_for_filthy_mobile_players)

func _input(event):
	if game_state == states.DEAD or game_state == states.WIN:
		if (event is InputEventKey && event.keycode == KEY_R) || (restart_with_left_click && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT):
			get_tree().reload_current_scene()

func check_game_over(water_level):
	if water_level == game_over_layer && game_state == states.PLAYING:
		game_state = states.DEAD
		rocket.visible = false
		var game_over_panel = $/root/MainScene/CanvasLayer/GameOver
		game_over_panel.visible = true
		var game_over_tween = get_tree().create_tween()
		game_over_tween.tween_property(game_over_panel, "modulate", Color(1, 1, 1, 1), 2).set_trans(Tween.TRANS_SINE)
		game_over_tween.tween_callback(game_over_for_filthy_mobile_players)

func game_over_for_filthy_mobile_players():
	restart_with_left_click = true
