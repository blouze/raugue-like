class_name IsDead extends HostileCondition


func tick(actor:Node, blackboard:Blackboard) -> int:
	var hostile = actor as Hostile
	
	hostile.playback
	return SUCCESS if hostile.playback.get_current_node() == "Die" else FAILURE
