class_name Tile extends Object


var options :Array:
	set(value):
		options = value
		
		entropy = options.size() - 1
#		print(pos, " -> ", options, " -> ", entropy)

var base_entropy := 0.0
var entropy :float
var pos :Vector2i
var neighbours := {}


func _init(_pos :Vector2i):
	pos = _pos


#func collapse(weights :Dictionary) -> Vector2i:


func collapse(weights :Dictionary) -> Vector2i:
	var total_weight := 0
	
	for option in options:
		total_weight += weights[option]
	
	var roll = randf()
	
	var sorted_option = options.duplicate()
	sorted_option.sort_custom(func(a, b): return weights[a] > weights[b])
	
	var atlas_coords = options.pick_random()
	
	var total := 0.0
	
	for option in sorted_option:
		total += weights[option]
		
		if roll < total / total_weight:
			atlas_coords = option
			break
	
	options = [atlas_coords]
	
	return atlas_coords


func constrain(ruleset :Array):
	if entropy > 0:
		var _options := []
		
		for option in options:
			if ruleset.has(option):
				_options.append(option)
		
		options = _options
