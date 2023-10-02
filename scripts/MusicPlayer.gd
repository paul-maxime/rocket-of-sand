extends AudioStreamPlayer

@export var next_music: AudioStream

func _ready():
	finished.connect(on_finished)

func on_finished():
	if stream != next_music:
		stream = next_music
		play()
