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
	
	var tiles_rect = game.tile_map.get_used_rect()
	
	var start = game.tile_map.map_to_local(tiles_rect.position) - game.tile_map.tile_set.tile_size * 0.5
	var end = game.tile_map.map_to_local(tiles_rect.end) - game.tile_map.tile_set.tile_size * 0.5
	
	cam_pos.x = max(cam_pos.x, start.x + Globals.SIZE.x * 0.5)
	cam_pos.x = min(cam_pos.x, end.x - Globals.SIZE.x * 0.5)
	
	cam_pos.y = max(cam_pos.y, start.y + Globals.SIZE.y * 0.5)
	cam_pos.y = min(cam_pos.y, end.y - Globals.SIZE.y * 0.5)
	
	actual_pos = lerp(actual_pos, cam_pos, pow(snap_player, 3) * delta * 60)
	
	var cam_offset := actual_pos.round() - actual_pos + offset
	container.material.set_shader_parameter("cam_offset", cam_offset)
	container.material.set_shader_parameter("tilt", rotation)
	
	offset = Vector2.ZERO
	rotation = 0
	
	global_position = actual_pos.round()
