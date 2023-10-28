class_name HostileStats extends Resource


const MAX_HEALTH := 3

var health := MAX_HEALTH

func hurt(amount):
	health -= amount
