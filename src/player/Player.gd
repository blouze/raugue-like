class_name Player extends CharacterBody2D


@export var movement :Movement
@export_range(0.0, 0.5) var fire_timer := 0.2
@export_range(100, 5000) var fire_speed := 300.0
@export_range(0.0, 0.2) var fire_accuracy := 0.1
@export var noise :Noise

@onready var anim_tree = $AnimationTree as AnimationTree
@onready var speed_bar = $SpeedBar as ProgressBar

var direction := Vector2.ZERO :
	set(value):
		direction = value

var aim := Vector2.ZERO

var timer := 0.0
var projectile_res = preload("res://src/projectiles/Projectile.tscn")

signal shoot(projectile :Projectile)
signal hurt(hostile :Hostile)


func _physics_process(delta):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	aim = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down")
	
	if aim.length() > 0:
		timer -= delta
		
		if timer < 0:
			var projectile = projectile_res.instantiate() as Projectile
			projectile.position = position + Vector2.RIGHT.rotated(aim.angle()) * 12
			
			var impulse = aim.normalized() * fire_speed
			impulse = impulse.rotated(PI * fire_accuracy * noise.get_noise_1d(Time.get_ticks_msec()))
			projectile.apply_central_impulse(impulse)
			
			projectile.rotation = impulse.angle()
			
			velocity -= impulse.normalized() * projectile.recoil * 0.15
			shoot.emit(projectile)
			
			timer = fire_timer
	else:
		timer = 0
	
	movement.speed_cur = velocity.length()
	
	velocity += movement.get_acceleration() * direction
	velocity += movement.get_friction() * velocity.normalized()
	
	move_and_slide()
	
	speed_bar.value = velocity.length() / movement.max_speed
	
	if aim.is_zero_approx():
		if direction.length() > 0:
			anim_tree["parameters/Idle/blend_position"] = direction
			anim_tree["parameters/Walk/blend_position"] = direction
	else:
		anim_tree["parameters/Idle/blend_position"] = aim
		anim_tree["parameters/Walk/blend_position"] = aim
