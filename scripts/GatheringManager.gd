extends Node2D

@export var click_particles: PackedScene

var gathering_speed = 1

func _ready():
	$'../EventManager'.block_clicked.connect(on_block_clicked)

func on_block_clicked(block_type, _layer, _coordinate, screen_coordinate, _wall_click):
	if block_type == 0:
		var particles: CPUParticles2D = click_particles.instantiate()
		particles.position = screen_coordinate
		particles.emitting = true
		particles.amount = gathering_speed
		add_child(particles)
		get_tree().create_timer(particles.lifetime).timeout.connect(particles.queue_free)
		$'../../ResourcesManager'.update_sand(gathering_speed)
		gathering_speed += 1
