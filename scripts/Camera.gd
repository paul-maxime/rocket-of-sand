extends Camera2D

const DRAG_MIN_DISTANCE = 5

var current_zoom = 2
var current_delta = Vector2()

var previous_click_position = Vector2()
var is_dragging: bool = false

var is_following_rocket: bool = false
var followed_rocket: Node2D

const min_x = -800
const max_x = 800
const min_y = -400
const max_y = 400

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			previous_click_position = event.position
		if event.button_index == MOUSE_BUTTON_WHEEL_UP && current_zoom < 10:
			current_zoom += 1
			zoom = Vector2(current_zoom, current_zoom)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && current_zoom > 2:
			current_zoom -= 1
			zoom = Vector2(current_zoom, current_zoom)
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if is_following_rocket:
			return
		if is_dragging or previous_click_position.distance_to(get_viewport().get_mouse_position()) > DRAG_MIN_DISTANCE:
			is_dragging = true
			current_delta += event.relative / current_zoom
			if current_delta.x < min_x: current_delta.x = min_x
			if current_delta.x > max_x: current_delta.x = max_x
			if current_delta.y < min_y: current_delta.y = min_y
			if current_delta.y > max_y: current_delta.y = max_y
			position = (-current_delta).round()

func _process(_delta):
	if is_following_rocket:
		position = followed_rocket.position

func start_following_rocket(rocket):
	is_following_rocket = true
	followed_rocket = rocket
	position_smoothing_enabled = true
	position_smoothing_speed = 5
	position = rocket.position
