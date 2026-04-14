extends Area2D

var speed = 300
var direction = Vector2.ZERO
var has_split = false
var is_split = false
var lifetime = 0.0
var distance_traveled = 0.0
var split_distance = 200.0

# called when bullet is fired, pass direction, whether its a split bullet, split distance and speed
func init(dir: Vector2, split: bool = false, dist: float = 200.0, spd: float = 300.0):
	direction = dir.normalized()
	is_split = split
	split_distance = dist
	speed = spd

func _physics_process(delta):
	var move = direction * speed * delta
	position += move
	distance_traveled += move.length()
	lifetime += delta

	# split bullets despawn after 2 seconds
	if is_split and lifetime >= 2.0:
		queue_free()
		return

	# once bullet travels the distance the player was at when fired, it splits
	if not is_split and not has_split and distance_traveled >= split_distance:
		has_split = true
		split()
		queue_free()

func split():
	# spawns 8 bullets evenly spread in 360 degrees
	var num_bullets = 8
	for i in range(num_bullets):
		var angle = (360.0 / num_bullets) * i
		var new_bullet = preload("res://scenes/UndeadSorcererSplitBullet.tscn").instantiate()
		new_bullet.position = global_position
		new_bullet.init(Vector2.RIGHT.rotated(deg_to_rad(angle)))
		get_tree().current_scene.add_child(new_bullet)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_hit(2)
		queue_free()
