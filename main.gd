class_name Game extends Node2D

@export var camera :CustomCamera2D
@export_range(0.0, 0.5) var shoot_stress = 0.1
@export_range(0.0, 0.5) var hit_stress = 0.15
@export_range(0.0, 0.5) var hurt_stress = 0.35
@export_range(0.0, 0.2) var freeze_frame = 0.02

@export var peaceful := false :
	set(value):
		peaceful = value
		
		if not is_inside_tree():
			await ready
		
		for hostile in get_tree().get_nodes_in_group("hostiles"):
			(hostile as Hostile).chasing = not peaceful

@export var sound_on := true :
	set(value):
		sound_on = value
		SoundManager.disabled = not sound_on

@onready var player = $%Player as Player
#@onready var hostile = $%Hostile as Hostile
@onready var tile_map = $%TileMap as TileMap


func _on_player_shoot(projectile :Projectile):
	SoundManager.play("res://assets/snd/click.wav")
	camera.stress(shoot_stress)
	
	add_child(projectile)


func _on_player_been_hurt(hostile :Hostile):
	SoundManager.play("res://assets/snd/hitHurt.wav")
	camera.stress(0.5)
	
	freeze()


func _on_hostile_been_hit(projectile :Projectile, hostile :Hostile):
	SoundManager.play("res://assets/snd/hitHurt.wav")
	camera.stress(hit_stress)
	
	var pos = lerp(projectile.position, hostile.position, 0.5)
	add_child(Impact.create(pos))
	
	freeze()


func _on_hostile_died(hostile :Hostile):
	pass # Replace with function body.


func _on_wall_been_hit(projectile :Projectile):
	SoundManager.play("res://assets/snd/hitHurt.wav")
	
	add_child(Impact.create(projectile.position))


func _ready():
	var cells = tile_map.get_used_cells_by_id(0, 0, Vector2i(11, 9))
	cells.shuffle()
	
	for i in range(5):
		var pos = tile_map.map_to_local(cells[i])
		tile_map.add_child(Hostile.create(self, pos))


func freeze():
	get_tree().paused = true
	await get_tree().create_timer(freeze_frame).timeout
	get_tree().paused = false
