class_name Hostile extends CharacterBody2D


@export var movement :Movement
@export var stats :HostileStats
@export var chasing := false
@export var player :Player

@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D
@onready var anim_tree = $AnimationTree as AnimationTree
@onready var playback = anim_tree["parameters/playback"] as AnimationNodeStateMachinePlayback

signal been_hit(hostile :Hostile)
signal died(hostile :Hostile)


var blend_pos := Vector2.ZERO :
	set(value):
		blend_pos = value
		
		anim_tree["parameters/Idle/blend_position"] = blend_pos
		anim_tree["parameters/Walk/blend_position"] = blend_pos
		anim_tree["parameters/Hit/blend_position"] = blend_pos
		anim_tree["parameters/Die/blend_position"] = blend_pos


func update_nav():
	pass
#	nav_agent.target_position = player.global_position


func hit(projectile :Projectile):
	stats.hurt(projectile.hit_value)
	
	velocity = (position - projectile.position).normalized() * projectile.recoil
	
	been_hit.emit(self)
	playback.travel("Die")
	
	if stats.health <= 0:
		died.emit(self)
		$CollisionShape2D.set_deferred("disabled", true)
		
		await get_tree().create_timer(3.0).timeout
		
		stats.health = stats.MAX_HEALTH
		$CollisionShape2D.disabled = false


func _physics_process(delta):
	movement.speed_cur = velocity.length()
	
	if ["Idle", "Walk"].has(playback.get_current_node()):
		
		if chasing:
			var direction = to_local(nav_agent.get_next_path_position()).normalized()
			velocity += movement.get_acceleration() * direction
			blend_pos = direction if direction.length() > 0 else velocity / movement.max_speed
		
		else:
			velocity = Vector2.ZERO
	
	velocity += movement.get_friction() * velocity.normalized()
	
	move_and_slide()


func _on_hurtbox_entered(body):
	print(body)
	if body is Player:
		body.hurt.emit(self)
