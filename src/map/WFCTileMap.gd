@tool
class_name WFCTileMap extends TileMap


enum { NORTH, WEST, SOUTH, EAST }

@export var dimensions := Vector2i(3, 3)

@export var template :WFCBaseTemplate:
	set(value):
		template = value
		
		tile_set = (template as WFCBaseTemplate).tile_set if template else null
		
		if tile_set:
			set_constraints()
		else:
			domain = {}

@export var regenerate := false:
	set(value):
		generate()

@export var reiterate := false:
	set(value):
		print(iterate())

@export var noise :FastNoiseLite

var tiles :Dictionary
var domain :Dictionary
var weights :Dictionary


func set_constraints():
	var template_rect = template.get_used_rect()
	var template_cells = template.get_used_cells(0)
	
	domain = {}
	weights = {}
	
	for cell in template_cells:
		var coords = template.get_cell_atlas_coords(0, cell)
		
		if not domain.has(coords):
			domain[coords] = { Vector2i.UP: [], Vector2i.RIGHT: [], Vector2i.DOWN: [], Vector2i.LEFT: [] }
			weights[coords] = 0
		
		for item in template.get_used_cells_by_id(0, -1, coords):
			for direction in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
				var neighbour = item + direction
				
				if neighbour.x < 0 or \
					neighbour.x >= (template_rect.position + template_rect.size).x or \
					neighbour.y < 0 or \
					neighbour.y >= (template_rect.position + template_rect.size).y:
						continue
				
				var atlas_coords = template.get_cell_atlas_coords(0, neighbour)
				
				if not domain[coords][direction].has(atlas_coords):
					domain[coords][direction].append(atlas_coords)
		
		weights[coords] += 1


func generate():
	var used_cells = get_used_cells(0)
	
	for cell in used_cells:
		set_cell(0, cell, -1)
	
	tiles = {}
	
	for j in range(dimensions.y):
		for i in range(dimensions.x):
			var pos = Vector2i(i, j)
			var neighbours := {}
			
			for direction in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
				var neighbour = pos + direction
				
				if neighbour.x < 0 or neighbour.x >= dimensions.x or \
					neighbour.y < 0 or neighbour.y >= dimensions.y:
					continue
				
				neighbours[direction] = neighbour
			
			var tile = Tile.new(pos)
			tile.options = domain.keys()
			tile.neighbours = neighbours
			
			tiles[Vector2i(i, j)] = tile
	
	var done := false
	var time = Time.get_ticks_msec()
	
	while not done:
		done = iterate()
	
	print("Map generated in %sms" % [Time.get_ticks_msec() - time])


func iterate():
	var lowest_entropy_tile = _get_lowest_entropy_tile()
	
	if not lowest_entropy_tile:
		return true
	
	var atlas_coords = lowest_entropy_tile.collapse(weights)
	set_cell(0, lowest_entropy_tile.pos, 0, atlas_coords)
	
	var stack := [lowest_entropy_tile]
	var count := 0
	
	while stack.size() > 0 and count < 500:
		count += 1
		
		var tile = stack.pop_front()
		
		for direction in tile.neighbours.keys():
			var rules := []
			
			for option in tile.options:
				rules.append_array(domain[option][direction])
			
			var neighbour :Tile = tiles[tile.neighbours[direction]]
			
			if neighbour.entropy > 0:
				var prev_entropy = neighbour.entropy
				neighbour.constrain(rules)
				
				if neighbour.entropy < prev_entropy:
					stack.append(neighbour)
			
			if neighbour.entropy == 0:
				set_cell(0, neighbour.pos, 0, neighbour.options[0])
	
	return false


func _get_lowest_entropy_tile():
	var S = domain.size()
	var low_tiles :Array[Tile] = []
	
	for tile in tiles.values():
		if tile.entropy > 0:
			if tile.entropy < S:
				low_tiles = [tile]
				S = tile.entropy
			
			elif tile.entropy == S:
				low_tiles.append(tile)
	
	return low_tiles.pick_random() if low_tiles.size() > 0 else null
