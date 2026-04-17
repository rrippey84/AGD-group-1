extends Area2D

var player = null
var speed = 120
var preferred_distance = 400.0
var too_close_distance = 300.0
var hp = 6

# strafe
var strafe_timer = 0.0
var strafe_interval = 1.0
var strafe_direction = 1  # 1 or -1

# shooting
var shots_fired = 0  # how many shots fired in current strafe cycle
var shoot_timer = 0.0
var first_shot_done = false
var waiting_for_second = false
var second_shot_timer = 0.0
var second_shot_delay = 0.4

# blink on hit
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

		# perpendicular strafe vector
		var strafe_vec = Vector2(-dir.y, dir.x) * strafe_direction

		if dist < too_close_distance:
			# back away from player
			position -= dir * speed * delta
		else:
			# strafe sideways, only close gap if too far
			if dist > preferred_distance:
				position += dir * (speed * 0.5) * delta
			position += strafe_vec * speed * delta

		# flip sprite to face player
		if dir.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false

		# strafe direction switch + shooting trigger
		strafe_timer += delta
		if strafe_timer >= strafe_interval:
			strafe_timer = 0.0
			strafe_direction *= -1
			# reset shot cycle for new strafe interval
			shots_fired = 0
			first_shot_done = false
			waiting_for_second = false
			second_shot_timer = 0.0

		# first shot fires shortly after strafe cycle starts
		if not first_shot_done and not waiting_for_second:
			shoot_timer += delta
			if shoot_timer >= 0.1:  # tiny delay so it doesn't fire the instant strafe resets
				shoot_bullet()
				first_shot_done = true
				waiting_for_second = true
				shoot_timer = 0.0

		# second shot fires after the 0.4s beat
		if waiting_for_second:
			second_shot_timer += delta
			if second_shot_timer >= second_shot_delay:
				shoot_bullet()
				waiting_for_second = false
				second_shot_timer = 0.0

func _process(delta):
	if is_blinking:
		blink_timer += delta
		if blink_timer >= blink_duration:
			is_blinking = false
			blink_timer = 0.0
			$Sprite2D.modulate = Color(1, 1, 1, 1)

func shoot_bullet():
	var bullet = preload("res://scenes/arrow_projectile.tscn").instantiate()
	bullet.position = global_position
	var dir = (player.global_position - global_position).normalized()
	bullet.init(dir)
	get_tree().current_scene.add_child(bullet)

func take_damage(damage: int):
	hp -= damage
	print("Archer HP: ", hp)
	blink()
	if hp <= 0:
		queue_free()

func blink():
	is_blinking = true
	blink_timer = 0.0
	$Sprite2D.modulate = Color(1, 0.3, 0.3, 1)
