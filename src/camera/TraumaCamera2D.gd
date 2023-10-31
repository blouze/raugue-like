class_name TraumaCamera2D extends Camera2D


@export_range(0.0, 0.5) var cooldown = 0.45
@export_range(0.0, 1.0) var max_angle = 1.0
@export_range(0.0, 32.0, 1.0) var max_offset := 12.0
@export var noise :Noise
@export var blur :ColorRect

var trauma := 0.0


func stress(stress_amount :float):
	trauma = min(trauma + stress_amount, 1.0)


func _physics_process(delta):
	var shake = pow(trauma, 3)
	
	var angle = shake * max_angle * TAU / 360.0
	var cam_offset = shake * max_offset
	
	rotation = angle * noise.get_noise_1d(0.1 * Time.get_ticks_msec())
	
	offset.x = cam_offset * noise.get_noise_1d(0.1 * Time.get_ticks_msec())
	offset.y = cam_offset * noise.get_noise_1d(0.1 * Time.get_ticks_msec() + 500)
	
	trauma = max(0.0, trauma * (1 - cooldown * 0.05))
	blur.material.set_shader_parameter("size", offset * pow(trauma, 3.0))


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			stress(1.0)
