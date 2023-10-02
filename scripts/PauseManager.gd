extends Node

var visibility_change_callback: JavaScriptObject

func _ready():
	if JavaScriptBridge != null:
		var document: JavaScriptObject = JavaScriptBridge.get_interface("document")
		if document != null:
			visibility_change_callback = JavaScriptBridge.create_callback(on_visibility_change)
			document.addEventListener("visibilitychange", visibility_change_callback)

func _notification(what):
	match what:
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
			get_tree().paused = false
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
			get_tree().paused = true

func on_visibility_change(_event):
	var document: JavaScriptObject = JavaScriptBridge.get_interface("document")
	if document != null:
		var visibility = JavaScriptBridge.get_interface("document").visibilityState
		if visibility == "hidden":
			get_tree().paused = true
		else:
			get_tree().paused = false
