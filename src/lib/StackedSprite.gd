@tool
class_name StackedSprite extends Sprite2D


func get_group_name():
	return "stack_%s" % get_instance_id()


@export var angle := 0.0 :
	set(value):
		angle = value
		
		for sprite in get_tree().get_nodes_in_group(get_group_name()):
			sprite.rotation = angle


func render_stack():
	print("render - %s " % get_group_name(), texture)
	clear_sprites()
	
	for i in range(0, vframes):
		var next :Sprite2D = Sprite2D.new()
		next.texture = texture
		next.vframes = vframes
		next.frame = vframes - 1 - i
		next.position.y = -i * 1.0
		next.add_to_group(get_group_name())
		add_child(next)


func clear_sprites():
	for sprite in get_tree().get_nodes_in_group(get_group_name()):
		sprite.call_deferred("queue_free")


func _set(property: StringName, value) -> bool:
	if property == "vframes":
		vframes = value
		clear_sprites()
			
		for i in range(vframes, 0):
			var next :Sprite2D = Sprite2D.new()
			next.texture = texture
			next.vframes = vframes
			next.frame = vframes - 1 - i
			next.position.y = -i * 1.0
			next.add_to_group(get_group_name())
			add_child(next)
		
		return true

	elif property == "texture":
		texture = value
		
		return true
	
	return false
