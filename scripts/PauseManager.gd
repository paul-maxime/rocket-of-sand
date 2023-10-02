extends Node

var tabcheat_callback: JavaScriptObject
var focuscheat_callback: JavaScriptObject

func _ready():
	if JavaScriptBridge != null:
		tabcheat_callback = JavaScriptBridge.create_callback(on_tab_cheat)
		focuscheat_callback = JavaScriptBridge.create_callback(on_focus_cheat)
		var document: JavaScriptObject = JavaScriptBridge.get_interface("document")
		if document != null:
			document.addEventListener("visibilitychange", tabcheat_callback)
			document.addEventListener("focusout", focuscheat_callback)

func _notification(what):
	match what:
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
			get_tree().paused = false
		MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
			get_tree().paused = true

func on_tab_cheat(event):
	print("on_tab_cheat ", event)

func on_focus_cheat(event):
	print("on_focus_cheat ", event)
