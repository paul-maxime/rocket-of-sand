extends Node2D

@export var click_particles: PackedScene
@onready var building_manager = $'../BuildingManager'
@onready var tile_map: TileMap = $'../../Island'
@onready var interface_layer: CanvasLayer = $/root/MainScene/CanvasLayer

var current_sand = 1000000
var gathering_power = 1

@onready var gathering_sounds = [$GatheringSound1, $GatheringSound2, $GatheringSound3, $GatheringSound4]

func _ready():
	$'../EventManager'.block_clicked.connect(on_block_clicked)
	$'../EventManager'.block_hovered.connect(on_block_hovered)

func on_block_clicked(block_type, layer, coordinates, screen_coordinates, wall_click):
	if block_type == 0 && !wall_click && !building_manager.build_mode:
		$/root/MainScene/GameManager.start_playing()
		increase_sand()
		gathering_sounds[randi_range(0, len(gathering_sounds) - 1)].play()
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
	interface_layer.update_sand(current_sand)

func update_power(delta):
	gathering_power += delta
	interface_layer.update_power(gathering_power)

func on_block_hovered(block_type, _layer, _coordinate, _screen_coordinate, wall_click):
	if block_type == 0 && !wall_click:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
