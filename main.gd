class_name Game extends Node2D

@export var camera :CustomCamera2D
@export_range(0.0, 0.5) var shoot_stress = 0.1
@export_range(0.0, 0.5) var hit_stress = 0.2
@export_range(0.0, 0.2) var freeze_frame = 0.1

@onready var player = $%Player as Player
#@onready var hostile = $%Hostile as Hostile
@onready var tile_map = $%TileMap as TileMap

var hostile_res = preload("res://src/hostiles/Hostile.tscn")
var impact_res = preload("res://src/projectiles/Impact.tscn")


func _on_player_shoot(projectile :Projectile):
	SoundManager.play("res://assets/snd/click.wav")
	camera.stress(shoot_stress)
	
	add_child(projectile)


func _on_player_hurt(assailant :Hostile):
	SoundManager.play("res://assets/snd/hitHurt.wav")
	player.velocity += (assailant.position - player.position).normalized() * 16


func _on_hostile_been_hit(projectile :Projectile, hostile :Hostile):
	SoundManager.play("res://assets/snd/hitHurt.wav")
	camera.stress(hit_stress)
	
	var impact = impact_res.instantiate() as Node2D
	impact.position = lerp(projectile.position, hostile.position, 0.5)
	add_child(impact)
	
	get_tree().paused = true
	await get_tree().create_timer(freeze_frame).timeout
	get_tree().paused = false


func _on_hostile_died(hostile :Hostile):
	pass # Replace with function body.


func _on_wall_been_hit(projectile :Projectile):
	SoundManager.play("res://assets/snd/hitHurt.wav")
	
	var impact = impact_res.instantiate() as Node2D
	impact.position = projectile.position
	add_child(impact)


func _ready():
	var cells = tile_map.get_used_cells_by_id(0, 0, Vector2i(11, 9))
	cells.shuffle()
	
	for i in range(10):
		var hostile = hostile_res.instantiate() as Hostile
		hostile.player = player
		hostile.position = tile_map.map_to_local(cells[i])
		hostile.been_hit.connect(_on_hostile_been_hit.bind(hostile))
		hostile.died.connect(_on_hostile_died.bind(hostile))
		tile_map.add_child(hostile)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	elif event.is_action_pressed("full_screen"):
		
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
