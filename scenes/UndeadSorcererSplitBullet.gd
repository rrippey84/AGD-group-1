extends Area2D

var speed = 350
var direction = Vector2.ZERO
var lifetime = 0.0

# called by MobProjectile when it splits
func init(dir: Vector2):
	direction = dir.normalized()

func _physics_process(delta):
	var move = direction * speed * delta
	position += move
	lifetime += delta
	# despawn after 4 seconds
	if lifetime >= 4.0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_hit(1)
		queue_free()
