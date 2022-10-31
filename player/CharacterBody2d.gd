extends CharacterBody2D


var speed = 100
@export var currPosition = position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	handle_input()
	
func handle_input():
	velocity = Vector2()
	
	if Input.is_key_pressed(KEY_W):
		velocity.y -= 1 * speed
	elif Input.is_key_pressed(KEY_S):
		velocity.y += 1 * speed
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1 * speed
	elif Input.is_key_pressed(KEY_D):
		velocity.x += 1 * speed
	
	velocity.normalized()
	move_and_slide()

func get_position():
	return position
