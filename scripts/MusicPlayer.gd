extends AudioStreamPlayer

@export var next_music: AudioStream

var is_fading_out: bool = false

func _ready():
	finished.connect(on_finished)

func on_finished():
	if stream != next_music and not is_fading_out:
		stream = next_music
		play()

func fadeout(time):
	get_tree().create_tween().bind_node(self).tween_property(self, "volume_db", -80, time)
