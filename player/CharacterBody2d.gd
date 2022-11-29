extends CharacterBody2D


@export var speed = 100
@export var currPosition = position
@export var hp_max = 100
@export var hp = 100
@export var defense = 5
var level = 0
var xp = 0



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


func receive_damage(base_damage):
	var actual_damage = base_damage
	actual_damage -= defense
	hp -= actual_damage
	print(hp)
	print(str(name) + " received " + str(actual_damage) + " damage")

func _on_hurtbox_area_entered(hitbox):
	receive_damage(hitbox.damage)
