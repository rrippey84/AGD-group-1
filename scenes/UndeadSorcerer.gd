extends Area2D

var player = null
var shoot_timer = 0.0
var shoot_interval = 3.0
var speed = 80
var preferred_distance = 400.0  # how far mob tries to stay from player
var too_close_distance = 300.0  # mob backs away if closer than this
var hp = 10
var blink_timer = 0.0
var blink_duration = 0.15
var is_blinking = false

func _physics_process(delta):
	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
	if player != null:
		var dist = global_position.distance_to(player.global_position)
		var dir = (player.global_position - global_position).normalized()
		if dist > preferred_distance:
			position += dir * speed * delta
		elif dist < too_close_distance:
			position -= dir * speed * delta
		# flip sprite to face player
		if dir.x < 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
	shoot_timer += delta
	if shoot_timer >= shoot_interval and player != null:
		shoot_timer = 0.0
		shoot_bullet()

func _process(delta):
	if is_blinking:
		blink_timer += delta
		if blink_timer >= blink_duration:
			is_blinking = false
			blink_timer = 0.0
			$Sprite2D.modulate = Color(1, 1, 1, 1)

func shoot_bullet():
	var bullet = preload("res://scenes/UndeadSorcererProjectile.tscn").instantiate()
	bullet.position = global_position
	var dir = (player.global_position - global_position).normalized()
	var random_offset = deg_to_rad(randf_range(-25, 25))  # random spread so shots aren't identical
	dir = dir.rotated(random_offset)
	var dist = global_position.distance_to(player.global_position)
	# TODO: adjust bullet speed and split distance as needed
	bullet.init(dir, false, dist, 450.0)
	get_tree().current_scene.add_child(bullet)

func take_damage(damage: int):
	hp -= damage
	print("Mob HP: ", hp)
	blink()
	if hp <= 0:
		queue_free()

func blink():
	is_blinking = true
	blink_timer = 0.0
	$Sprite2D.modulate = Color(1, 0.3, 0.3, 1)  # red tint on hit
