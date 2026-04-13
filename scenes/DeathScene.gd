extends CanvasLayer

@onready var fade_rect = $FadeRect
@onready var perished_label = $PerishedLabel
@onready var text_box = $TextBox
@onready var typed_label = $TextBox/TypedLabel
@onready var retry_button = $RetryButton

var full_text = "YOU FAIL... AND WITH YOU, YOUR SPECIES DIES OFF. NO MALES REMAIN TO CONTINUE BREEDING."
var typed_text = ""
var char_index = 0
var typing_speed = 0.05  # seconds per character
var typing_timer = 0.0

var fade_duration = 1.33
var fade_timer = 0.0
var is_fading = true
var show_perished = false
var is_typing = false

func _ready():
	retry_button.pressed.connect(_on_retry_pressed)

func _process(delta):
	# fade to black
	if is_fading:
		fade_timer += delta
		fade_rect.color.a = clamp(fade_timer / fade_duration, 0.0, 1.0)
		if fade_timer >= fade_duration:
			is_fading = false
			show_perished = true
			perished_label.visible = true
			# wait a moment then show text box
			await get_tree().create_timer(1.0).timeout
			text_box.visible = true
			is_typing = true

	# type out the text in text bar
	if is_typing:
		typing_timer += delta
		if typing_timer >= typing_speed and char_index < full_text.length():
			typing_timer = 0.0
			char_index += 1
			typed_label.text = full_text.substr(0, char_index)
		if char_index >= full_text.length():
			is_typing = false
			retry_button.visible = true

func _on_retry_pressed():
	# TODO: change to actual first level scene name
	get_tree().change_scene_to_file("res://scenes/TestScene.tscn")
