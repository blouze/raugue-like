extends Node


const SIZE := Vector2(320, 180)
const hostile_res = preload("res://src/hostiles/Hostile.tscn")

var balloon :Balloon


func show_dialog(resource: DialogueResource, title: String = "", extra_game_states: Array = []):
	if balloon:
		balloon.queue_free()
	
	get_tree().paused = true
	
	balloon = DialogueManager.show_dialogue_balloon(resource, "start") as Balloon
	balloon.process_mode = Node.PROCESS_MODE_ALWAYS
	
	balloon.dialogue_label.spoke.connect(func(letter: String, letter_index: int, speed: float):
		if letter_index % 4 == 0:
			SoundManager.play("res://assets/snd/word.wav")
	)


func _ready():
	DialogueManager.dialogue_ended.connect(func(resource :DialogueResource):
		print("yeah")
		get_tree().paused = false
		balloon = null
	)
