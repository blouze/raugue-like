class_name Projectile extends RigidBody2D


static var projectile_res = preload("res://src/projectiles/Projectile.tscn")

var hit_value := 1
var recoil := 50.0


func _on_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(self)
	
	queue_free()


static func create(pos :Vector2, impulse :Vector2) -> Projectile:
	var projectile = projectile_res.instantiate() as Projectile
	
	projectile.position = pos
	projectile.rotation = impulse.angle()
	projectile.apply_central_impulse(impulse)
	
	return projectile
