class_name Actionable extends  Area2D


@export var dialogue_res :DialogueResource
@export var dialogue_start := "start"

@onready var icon = $Sprite2D as Sprite2D

signal changed()



var is_actionable := false :
	set(value):
		is_actionable = value
		
		icon.visible = is_actionable
		changed.emit()


func _ready():
	self.is_actionable = false


func _on_body_entered(body):
	if body is Player:
		self.is_actionable = true


func _on_body_exited(body):
	if body is Player:
		self.is_actionable = false


func execute():
	if not dialogue_res:
		return
	
	is_actionable = false
	
	Globals.show_dialog(dialogue_res, "start")
