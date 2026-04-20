extends Area2D

var damage_timer = 0.0
var damage_interval = 0.6  # seconds between each damage tick
var players_inside = []

func _process(delta):
	if players_inside.size() > 0:
		damage_timer += delta
		if damage_timer >= damage_interval:
			damage_timer = 0.0  # reset timer after each damage tick
			for player in players_inside:
				if is_instance_valid(player):
					player.take_hit(1)  # damage dealt per tick

func _on_body_entered(body):
	if body.is_in_group("player"):
		players_inside.append(body)
		body.speed *= 0.75  # slow player by 25% on enter

func _on_body_exited(body):
	if body.is_in_group("player"):
		players_inside.erase(body)
		body.speed /= 0.75  # restore speed on exit
