extends Control


@onready var singleplayer = false
@onready var set_singleplayer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if singleplayer and not set_singleplayer:
		if get_tree() != null:
			set_singleplayer = true
			var root = get_tree().root
			var game_controller = root.get_child(root.get_child_count() - 1)
			game_controller.singleplayer = true
			

func _on_singleplayer_button_pressed():
	#get_tree().change_scene_to_file("res://level/bullethaven.tscn")
	get_tree().change_scene_to_file("res://singleton/game.tscn")
	singleplayer = true
	
	

func _on_multiplayer_button_pressed():
	#get_tree().change_scene_to_file("res://level/bullethaven.tscn")
	get_tree().change_scene_to_file("res://singleton/game.tscn")



func _on_quit_button_pressed():
	get_tree().quit()


func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://menus/Options/OptionsMenu.tscn")




func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menus/MainMenu/mainmenu.tscn")
