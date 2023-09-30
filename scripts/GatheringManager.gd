extends Node2D

@export var click_particles: PackedScene

var current_sand = 0
var gathering_power = 1

func _ready():
	$'../EventManager'.block_clicked.connect(on_block_clicked)
	$'../EventManager'.block_hovered.connect(on_block_hovered)

func on_block_clicked(block_type, _layer, _coordinate, screen_coordinate, wall_click):
	if block_type == 0 && !wall_click:
		var particles: CPUParticles2D = click_particles.instantiate()
		particles.position = screen_coordinate
		particles.emitting = true
		particles.amount = gathering_power
		add_child(particles)
		get_tree().create_timer(particles.lifetime).timeout.connect(particles.queue_free)
		current_sand += gathering_power
		$/root/MainScene/CanvasLayer.update_sand(current_sand)
		gathering_power += 1

func on_block_hovered(block_type, _layer, _coordinate, _screen_coordinate, wall_click):
	if block_type == 0 && !wall_click:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
