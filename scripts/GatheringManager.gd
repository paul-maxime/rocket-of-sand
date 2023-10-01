extends Node2D

@export var click_particles: PackedScene
@onready var building_manager = $'../BuildingManager'
@onready var tile_map: TileMap = $'../../Island'

var current_sand = 0
var gathering_power = 1

func _ready():
	$'../EventManager'.block_clicked.connect(on_block_clicked)
	$'../EventManager'.block_hovered.connect(on_block_hovered)

func on_block_clicked(block_type, layer, coordinates, screen_coordinates, wall_click):
	if block_type == 0 && !wall_click && !building_manager.build_mode:
		increase_sand()
		create_gathering_particles(screen_coordinates)
		tile_map.erase_sand(layer, coordinates)

func increase_sand():
	add_sand(gathering_power)

func create_gathering_particles(screen_coordinates):
	var particles: CPUParticles2D = click_particles.instantiate()
	particles.position = screen_coordinates
	particles.emitting = true
	particles.amount = gathering_power
	add_child(particles)
	get_tree().create_timer(particles.lifetime).timeout.connect(particles.queue_free)


func add_sand(amount):
	current_sand += amount
	$/root/MainScene/CanvasLayer.update_sand(current_sand)

func update_power(delta):
	gathering_power += delta
	$/root/MainScene/CanvasLayer.update_power(gathering_power)

func on_block_hovered(block_type, _layer, _coordinate, _screen_coordinate, wall_click):
	if block_type == 0 && !wall_click:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
