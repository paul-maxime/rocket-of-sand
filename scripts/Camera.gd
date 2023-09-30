extends Camera2D

const DRAG_MIN_DISTANCE = 5

var current_zoom = 2
var current_delta = Vector2()

var previous_click_position = Vector2()
var is_dragging: bool = false

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
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && current_zoom > 1:
			current_zoom -= 1
			zoom = Vector2(current_zoom, current_zoom)
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if is_dragging or previous_click_position.distance_to(get_viewport().get_mouse_position()) > DRAG_MIN_DISTANCE:
			is_dragging = true
			current_delta += event.relative / current_zoom
			position = -current_delta
