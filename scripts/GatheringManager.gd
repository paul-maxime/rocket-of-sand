extends Node2D

@export var click_particles: PackedScene
@onready var building_manager = $'../BuildingManager'

var current_sand = 0
var gathering_power = 1
var factory_power = 0
var factory_bonus = 1000

func _ready():
	$'../EventManager'.block_clicked.connect(on_block_clicked)
	$'../EventManager'.block_hovered.connect(on_block_hovered)

func on_block_clicked(block_type, _layer, _coordinate, screen_coordinate, wall_click):
	if block_type == 0 && !wall_click && !building_manager.build_mode:
		var sand_amount = gathering_power + factory_power * 1000
		var particles: CPUParticles2D = click_particles.instantiate()
		particles.position = screen_coordinate
		particles.emitting = true
		particles.amount = sand_amount
		add_child(particles)
		get_tree().create_timer(particles.lifetime).timeout.connect(particles.queue_free)
		add_sand(sand_amount)
		gathering_power += 1

func add_sand(amount):
		current_sand += amount
		$/root/MainScene/CanvasLayer.update_sand(current_sand)

func on_block_hovered(block_type, _layer, _coordinate, _screen_coordinate, wall_click):
	if block_type == 0 && !wall_click:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
