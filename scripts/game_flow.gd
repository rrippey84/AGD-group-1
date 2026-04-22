extends Node

# TODO: confirm level order with others
var levels = [
	"res://beggining.tscn",  # TODO: confirm this is what the start is
	"res://scenes/Kegan_outside1.tscn",
	"res://scenes/Kegan_outside2.tscn",
	"res://scenes/Kegan_outside3.tscn",
	"res://scenes/Kegan_lava_cavern1.tscn",
	"res://scenes/Kegan_lava_cavern2.tscn",
	"res://scenes/Kegan_lava_cavern3.tscn",
	"res://scenes/Kegan_lava_cavern4.tscn",
	"res://scenes/Kegan_lava_cavern5.tscn",
]

var current_level_index = 0

func go_to_next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		get_tree().change_scene_to_file(levels[current_level_index])
	else:
		# TODO: go to win screen/credits
		get_tree().change_scene_to_file("res://scenes/cutscene_win.tscn")

func restart_game():
	current_level_index = 0
	get_tree().change_scene_to_file(levels[0])
