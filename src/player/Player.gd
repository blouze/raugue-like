class_name Player extends CharacterBody2D


@export var movement :Movement
@export_range(0.0, 0.5) var fire_time := 0.2
@export_range(100, 5000) var fire_speed := 300.0
@export_range(0.0, 0.2) var fire_accuracy := 0.1
@export_range(0.0, 2.0) var hurt_time := 1.0
@export var noise :Noise

@onready var anim_tree = $AnimationTree as AnimationTree
@onready var playback = anim_tree["parameters/playback"] as AnimationNodeStateMachinePlayback
@onready var hit_box = $Hitbox as CollisionShape2D
@onready var speed_bar = $SpeedBar as ProgressBar

const animations = ["Idle", "Walk", "Hit", "Die"]

var direction := Vector2.ZERO
var aim := Vector2.ZERO

var fire_timer := 0.0
var hurt_timer := 0.0

signal shoot(projectile :Projectile)
signal been_hurt(hostile :Hostile)


var blend_pos := Vector2.ZERO :
	set(value):
		blend_pos = value
		
		for animation in animations:
			anim_tree["parameters/%s/blend_position" % animation] = blend_pos


func hurt(hostile :Hostile):
	var dir = (position - hostile.position).normalized()
	
	velocity = dir * 128
	direction = Vector2.ZERO
	
	blend_pos = -dir
	playback.travel("Hit")
	
	collision_layer = 0
	hurt_timer = hurt_time
	
	been_hurt.emit(hostile)


func _physics_process(delta):
	if hurt_timer > 0:
		hurt_timer -= delta
	
	else:
		collision_layer = 1
		
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		aim = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down")
		
		if aim.length() > 0:
			fire_timer -= delta
			
			if fire_timer < 0:
				var pos = position + Vector2.RIGHT.rotated(aim.angle()) * 12
				
				var impulse = aim.normalized() * fire_speed
				impulse = impulse.rotated(PI * fire_accuracy * noise.get_noise_1d(Time.get_ticks_msec()))
				
				var projectile = Projectile.create(pos, impulse)
				
				velocity -= impulse.normalized() * projectile.recoil * 0.15
				shoot.emit(projectile)
				
				fire_timer = fire_time
		else:
			fire_timer = 0
		
		if aim.is_zero_approx():
			if direction.length() > 0:
				blend_pos = direction
		
		else:
			blend_pos = aim
	
	velocity += movement.get_acceleration(velocity.length()) * direction
	velocity += movement.get_friction(velocity.length()) * velocity.normalized()
	
	move_and_slide()
	
	speed_bar.value = velocity.length() / movement.max_speed
