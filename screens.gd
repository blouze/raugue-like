extends Control


@onready var menu = $%Menu


func _ready():
	menu.visible = false


func _input(event):
	if event.is_action_pressed("start"):
		get_tree().paused = not get_tree().paused
		menu.visible = get_tree().paused
	
	elif event.is_action_pressed("full_screen"):
		
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()
