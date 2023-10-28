class_name Movement extends Resource

@export_range(10, 200) var max_speed = 50
@export_range(1, 10) var acc = 2
@export_range(1, 10) var k = 5
@export var acceleration :Curve = Curve.new()
@export var friction :Curve = Curve.new()

const WALK_THRESHOLD := 4.0

var speed_cur := 0.0


func get_acceleration() -> float:
	var f := 0.0
	
	f += acceleration.sample_baked(speed_cur / max_speed) * acc
	
	return f


func get_friction() -> float:
	var f := 0.0
	
	f -= friction.sample_baked(speed_cur / max_speed) * k
	
	return f
