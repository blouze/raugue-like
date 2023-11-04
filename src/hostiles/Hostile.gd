class_name Hostile extends CharacterBody2D


const animations = ["Idle", "Walk", "Hit", "Die"]
const proximity := 100.0

signal been_hit(projectile :Projectile)
signal died()

@export var movement :Movement
@export var stats :HostileStats
@export var chasing := false
@export var player :Player

@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D
@onready var anim_tree = $AnimationTree as AnimationTree
@onready var playback = anim_tree["parameters/playback"] as AnimationNodeStateMachinePlayback


var blend_pos := Vector2.ZERO :
	set(value):
		blend_pos = value

		for animation in animations:
			anim_tree["parameters/%s/blend_position" % animation] = blend_pos


func hit(projectile :Projectile):
	stats.hurt(projectile.hit_value)

	velocity = (position - projectile.position).normalized() * projectile.recoil

	been_hit.emit(projectile)
	playback.travel("Die")

	if stats.health <= 0:
		died.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		$HurtBox.set_deferred("monitoring", false)

		await get_tree().create_timer(3.0).timeout

		stats.health = stats.MAX_HEALTH
		$CollisionShape2D.disabled = false
		$HurtBox.set_deferred("monitoring", true)


func _ready():
	($Blackboard as Blackboard).set_value("hostiles_nav_update_ticker", 0)

func _physics_process(delta):
#	if ["Idle", "Walk"].has(playback.get_current_node()):
#
#		if chasing:
#			var direction = to_local(nav_agent.get_next_path_position()).normalized()
#			velocity += movement.get_acceleration(velocity.length()) * direction
#			blend_pos = direction if direction.length() > 0 else velocity / movement.max_speed
#
#		else:
#			velocity = Vector2.ZERO

	velocity += movement.get_friction(velocity.length()) * velocity.normalized()

	move_and_slide()


func _on_hurtbox_entered(body):
#	print(body)
	if body is Player:
		body.hurt(self)


static func create(game :Game, pos :Vector2) -> Hostile:
	var hostile = Globals.hostile_res.instantiate() as Hostile

	hostile.player = game.player
	hostile.position = pos
	hostile.been_hit.connect(game._on_hostile_been_hit.bind(hostile))
	hostile.died.connect(game._on_hostile_died.bind(hostile))

	return hostile
