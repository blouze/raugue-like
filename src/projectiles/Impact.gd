class_name Impact extends Node2D


static var impact_res = preload("res://src/projectiles/Impact.tscn")


static func create(pos :Vector2) -> Impact:
	var impact = impact_res.instantiate() as Impact
	
	impact.position = pos
	
	return impact
