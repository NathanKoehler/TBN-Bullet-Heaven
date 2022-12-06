extends CharacterBody2D

signal hp_changed(new_hp)
signal died


@export var speed = 100 : 
	set(value):
		speed = value 
	get:
		return speed
@export var currPosition = position
@export var hp_max = 100 : 
	set(value):
		hp_max = value
	get:
		return hp_max
@export var hp = 100 : 
	set(value):
		if value != hp:
			hp = clamp(value, 0, hp_max)
			emit_signal("hp_changed", hp)
			if hp == 0:
				emit_signal("died")
	get:
		return hp
@export var defense = 5 : 
	set(value):
		defense = value
	get:
		return defense
@export var level = 0 : 
	set(value):
		level = value
	get:
		return level
@export var xp = 0

#Scene references
@export var effect_hit = preload("res://effects/hit_effect.tscn")
@export var effect_death = preload("res://effects/death_effect.tscn")
@export var magic_bullet = preload("res://player/player_spells/magic_bullet.tscn")



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



func _on_player_died():
	print("player has died")
	

# spell functions
func shoot_magic_bullet():
	if magic_bullet:
		var mb = magic_bullet.instantiate()
		get_tree().current_scene.add_child(mb)
		#add_child(mb)
		mb.global_position = self.global_position
		
		var mb_rotation = self.global_position.direction_to(get_global_mouse_position()).angle()
		mb.rotation = mb_rotation


func _on_magic_bullet_timer_timeout():
	shoot_magic_bullet()

func spawn_effect(EFFECT: PackedScene, effect_pos: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_pos
