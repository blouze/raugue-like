@tool
class_name Map extends WFCTileMap
#class_name Map extends TileMap


signal been_hit(projectile :Projectile)


func hit(projectile :Projectile):
	been_hit.emit(projectile)
