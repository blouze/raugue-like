class_name CustomCamera2D extends TraumaCamera2D


@export var container :SubViewportContainer
@export var game :Game
@export_range(0.0, 1.0) var snap_player = 0.4
@export_range(0.0, 1.0) var anticipation = 0.5

@onready var actual_pos :Vector2 = game.player.global_position


func _physics_process(delta):
	super._physics_process(delta)
	
	var cam_pos = game.player.global_position
	cam_pos += game.player.velocity * anticipation * delta * 60
	
	actual_pos = lerp(actual_pos, cam_pos, pow(snap_player, 3) * delta * 60)
	
	var cam_offset := actual_pos.round() - actual_pos + offset
	container.material.set_shader_parameter("cam_offset", cam_offset)
	
	offset = Vector2.ZERO
	
	global_position = actual_pos.round()
