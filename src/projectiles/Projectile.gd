class_name Projectile extends RigidBody2D


var hit_value := 1
var recoil := 50.0


func _on_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(self)
	
	queue_free()
