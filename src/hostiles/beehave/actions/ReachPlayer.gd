class_name ReachPlayer extends HostileAction


@export_range(0, 10, 1) var nav_update_ticks = 5


func tick(actor:Node, blackboard:Blackboard) -> int:
	var hostile = actor as Hostile
	
	var ticker = blackboard.get_value("hostiles_nav_update_ticker")
	
	if ticker <= 0:
		hostile.nav_agent.target_position = hostile.player.global_position
		blackboard.set_value("hostiles_nav_update_ticker", nav_update_ticks)
	
	else:
		blackboard.set_value("hostiles_nav_update_ticker", ticker - 1)

	var direction = hostile.to_local(hostile.nav_agent.get_next_path_position()).normalized()
	
	hostile.velocity += hostile.movement.get_acceleration(hostile.velocity.length()) * direction
	hostile.blend_pos = hostile.velocity / hostile.movement.max_speed
	
	return SUCCESS
