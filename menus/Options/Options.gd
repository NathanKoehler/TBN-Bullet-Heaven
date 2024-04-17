extends Control

@onready var ResOptionButton = $VBoxContainer/OptionButton

var Resolutions: Dictionary = {"1152x648":Vector2(1152, 648),
								"1280x720":Vector2(1280, 720),
								"1366x768":Vector2(1366, 768),
								"1536x864":Vector2(1536, 864),
								"1600x900":Vector2(1600, 900),
								"1920x1080":Vector2(1920, 1080)}

func _ready():
	addResolutions()
	
func addResolutions():
	for r in Resolutions:
		ResOptionButton.add_item(r)

func _on_option_button_item_selected(index):
	var size = Resolutions.get(ResOptionButton.get_item_text(index))
	DisplayServer.window_set_size(size)
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menus/MainMenu/mainmenu.tscn")

