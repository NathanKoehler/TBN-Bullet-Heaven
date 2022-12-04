extends "res://enemies/Hitbox.gd"


@export var speed = 100
@onready var animation_player = $AnimationPlayer


func _physics_process(delta):
	animation_player.play("shoot")
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta


func destroy():
	queue_free()


func _on_magic_bullet_area_entered(area):
	destroy()


func _on_magic_bullet_body_entered(body):
	destroy()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
