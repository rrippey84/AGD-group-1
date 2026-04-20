extends StaticBody2D

@onready var label: Label = $dialogue/Label
@onready var dialogue: CanvasLayer = $dialogue
@onready var area : StaticBody2D = $"."

var is_playing : bool = false

func type_out_text(text: String, delay: float = 0.2):
	var displayed = ""
	
	for char in text:
		await get_tree().create_timer(delay).timeout
		displayed += char
		label.text = displayed
	
	await get_tree().create_timer(1).timeout  # ← Add await here
	
	is_playing = false
	label.text = ""
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed() and not is_playing:
		type_out_text("You must go, traveler!",0.05)
