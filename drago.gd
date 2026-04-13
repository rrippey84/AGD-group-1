extends CharacterBody2D

var speed: float = 200.0
var max_health: int = 5
var health: int = max_health

var fireball_scene: PackedScene = preload("res://Fireball.tscn")
var shoot_cooldown: float = 0.3
var can_shoot: bool = true

# Placeholder death scene
var death_scene_path: String = "res://DeathCutscenePlaceholder.tscn"


func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	velocity = input_vector.normalized() * speed
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		shoot_fireball()


func shoot_fireball() -> void:
	if not can_shoot:
		return

	can_shoot = false

	var fireball = fireball_scene.instantiate()
	fireball.global_position = global_position

	# Fireball direction = where the player last moved or aimed
	var dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT  # default direction if standing still

	fireball.direction = dir.normalized()
	get_tree().current_scene.add_child(fireball)

	# Cooldown timer
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true


func take_hit(amount: int = 1) -> void:
	health -= amount
	health = clamp(health, 0, max_health)

	if health <= 0:
		trigger_death_cutscene()


func trigger_death_cutscene() -> void:
	get_tree().change_scene_to_file(death_scene_path)
