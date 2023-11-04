class_name DoNothing extends HostileAction


func tick(actor:Node, blackboard:Blackboard) -> int:
	var hostile = actor as Hostile
	
	hostile.blend_pos = (hostile.player.position - hostile.position).normalized()
	
	return SUCCESS
