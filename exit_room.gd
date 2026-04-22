extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		# check if all mobs are dead before advancing
		if get_tree().get_nodes_in_group("mob").size() == 0:
			GameFlow.go_to_next_level()
