extends TextureProgressBar

var tween = create_tween()


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().get_idle_frames()
	value = get_parent().hp
	max_value = get_parent().hp_max


func animate_hp_change(new_hp: int, old_hp: float = value):
	tween.interpolate_property(self, "value", old_hp, new_hp, .1, 
	tween.TRANS_SINE, tween.EASE_IN_OUT, .025)
	tween.start()
