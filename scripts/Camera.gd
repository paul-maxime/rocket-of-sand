extends Camera2D

var current_zoom = 1
var current_delta = Vector2()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP && current_zoom < 10:
			current_zoom += 1
			resize()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && current_zoom > 1:
			current_zoom -= 1
			resize()
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		current_delta += event.relative / current_zoom
		position = -current_delta


func resize():
	zoom = Vector2(current_zoom, current_zoom)
