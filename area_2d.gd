extends Area2D

var speed: float = 400.0
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
