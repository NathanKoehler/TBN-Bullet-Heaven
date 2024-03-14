extends "res://enemies/Hitbox.gd"


@export var speed = 100
@onready var animation_player = $AnimationPlayer


func _physics_process(delta):
	animation_player.play("default")


func destroy():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	destroy()
