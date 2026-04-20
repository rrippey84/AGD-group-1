extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.speed *= 0.33  # slow by 33%

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.speed /= 0.5  # restore speed
