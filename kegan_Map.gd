extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$player.position = $enter.position
