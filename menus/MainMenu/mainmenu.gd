extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_button_pressed():
	#get_tree().change_scene_to_file("res://level/bullethaven.tscn")
	get_tree().change_scene_to_file("res://singleton/game.tscn")



func _on_quit_button_pressed():
	get_tree().quit()


func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://menus/Options/OptionsMenu.tscn")




func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menus/MainMenu/mainmenu.tscn")
