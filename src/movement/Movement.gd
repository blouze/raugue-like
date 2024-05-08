class_name Movement extends Resource

@export_range(100, 500) var max_speed = 150
@export_range(10, 50) var acc = 20
@export_range(10, 50) var k = 10
@export var acceleration :Curve = Curve.new()
@export var friction :Curve = Curve.new()

const WALK_THRESHOLD := 4.0


func get_acceleration(speed :float) -> float:
	var f := 0.0
	
	f += acceleration.sample_baked(speed / max_speed) * acc
	
	return f


func get_friction(speed :float) -> float:
	var f := 0.0
	
	f -= friction.sample_baked(speed / max_speed) * k
	
	return f
