extends CenterContainer
class_name PauseMenu

static var paused = false;

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.hide()

func unpause():
	self.hide()
	paused = false
	get_tree().paused = false
	
func pause():
	self.show()
	paused = true
	get_tree().paused = true


func _on_resume_button_down() -> void:
	unpause()


func _on_quit_button_up() -> void:
	get_tree().quit


func _on_quit_button_down() -> void:
	get_tree().quit()
