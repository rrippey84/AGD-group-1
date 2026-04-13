extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var interacted :Object = null

func _process(delta):
	velocity = Input.get_vector("ui_left", "ui_right","ui_up", "ui_down")
	position += velocity * SPEED * delta
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action_pressed('interact') and interacted != null:
			pass
			

func _on_area_2d_area_entered(area: Area2D) -> void:
	var hover = area.find_child('hover',true)
	if not hover: return
	var event_names = []
	
	for event in InputMap.action_get_events("interact"):
		var display_name = ""

		if event is InputEventKey:
			# For Keyboard: Get clean name (e.g., "E", "Shift", "Space")
			display_name = OS.get_keycode_string(event.physical_keycode)
			if display_name == "": 
				display_name = OS.get_keycode_string(event.keycode)
				
		elif event is InputEventJoypadButton:
			# For Controller: Returns "Joypad Button 0 (PS Cross, Xbox A)" 
			# We can clean this to just show the button name
			display_name = event.as_text().split(" (")[0]
			
		elif event is InputEventMouseButton:
			# For Mouse: Returns "Mouse Button 1 (Left Button)" -> "Left Button"
			display_name = event.as_text().split(" (")[-1].replace(")", "")

		if display_name != "":
			event_names.append(display_name)

	# Join them together
	var final_string = " / ".join(event_names)
	hover.text = "%s" % final_string
	
	hover.visible = true
	interacted = area
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	interacted = null
	var hover = area.find_child('hover',true)
	if not hover: return
	hover.visible = false
	
