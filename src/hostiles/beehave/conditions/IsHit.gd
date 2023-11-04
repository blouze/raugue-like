class_name IsHit extends HostileCondition


func tick(actor:Node, blackboard:Blackboard) -> int:
	var hostile = actor as Hostile
	
	return SUCCESS if hostile.playback.get_current_node() == "Hit" else FAILURE
