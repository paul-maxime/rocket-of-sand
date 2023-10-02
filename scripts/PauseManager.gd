extends Node

func _notification(what):
	match what:
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
			get_tree().paused = false
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
			get_tree().paused = true
