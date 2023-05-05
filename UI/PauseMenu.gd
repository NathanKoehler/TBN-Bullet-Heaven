extends CenterContainer


@onready var play_button: Button = get_node("PanelContainer/MarginContainer/VBoxContainer/Resume")
@onready var quit_button: Button = get_node("PanelContainer/MarginContainer/VBoxContainer/Quit")

func _ready():
	play_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func unpause():
	self.hide()
	get_tree().paused = false
	
func pause():
	self.show()
	get_tree().paused = true
