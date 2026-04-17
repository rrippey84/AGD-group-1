extends Area2D

var speed = 500
var direction = Vector2.ZERO
var lifetime = 0.0

func init(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle() + deg_to_rad(-90)

func _physics_process(delta):
	var move = direction * speed * delta
	position += move
	lifetime += delta
	if lifetime >= 3.0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)
		queue_free()
