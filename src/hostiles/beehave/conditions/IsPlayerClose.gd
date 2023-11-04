class_name IsPlayerClose extends HostileCondition


@export_range(10, 100, 1) var proximity = 60


func tick(actor:Node, blackboard:Blackboard) -> int:
	var hostile = actor as Hostile
	
	return hostile.player.position.distance_to(hostile.position) <= proximity
