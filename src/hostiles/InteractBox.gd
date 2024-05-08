class_name InteractBox extends Area2D


@onready var icon = $Sprite2D as Sprite2D

signal changed(active :bool)


var is_active := false :
	set(value):
		is_active = value
		
		icon.visible = is_active
		changed.emit()


func _ready():
	self.is_active = false


func _on_body_entered(body):
	if body is Player:
		is_active = true


func _on_body_exited(body):
	if body is Player:
		is_active = false
