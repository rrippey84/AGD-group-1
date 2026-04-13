extends Node2D

@onready var sprite = $Sprite2D
@onready var fade_rect = $ColorRect

func move_to(target: Vector2, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "position", target, duration)

func fade_in(duration: float = 1.0):
	fade_rect.visible = true
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)

func fade_out(duration: float = 1.0):
	fade_rect.visible = true
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
