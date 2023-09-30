extends Camera2D

const MAP_WIDTH = 400
const MAP_HEIGHT = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().size_changed.connect(on_resize)
	on_resize()

func on_resize():
	var viewport_size = get_viewport_rect().size
	var max_width_ratio = floor(viewport_size.x / MAP_WIDTH)
	var max_height_ratio = floor(viewport_size.y / MAP_HEIGHT)
	var ratio = max(max_width_ratio, max_height_ratio)
	zoom = Vector2(ratio, ratio)
