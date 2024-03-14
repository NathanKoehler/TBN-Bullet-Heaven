extends "res://enemies/Hitbox.gd"


@export var speed = 300
@onready var animation_player = $AnimationPlayer


func _physics_process(delta):
	animation_player.play("default")
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta


func destroy():
	queue_free()

