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
@export var xp_max = 5

#Scene references
@export var effect_hit = preload("res://effects/hit_effect.tscn")
@export var effect_death = preload("res://effects/death_effect.tscn")
@export var magic_bullet = preload("res://player/player_spells/magic_bullet.tscn")
@export var lightning = preload("res://player/player_spells/lightning.tscn")

#general vars
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()


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

func shoot_lightning(enemy_array):
	if lightning:
		for enemy in enemy_array:
			if enemy.get_node("notifier").is_on_screen():
				var bolt = lightning.instantiate()
				get_tree().current_scene.add_child(bolt)
				bolt.global_position = enemy.global_position
				break
		
		

func _on_lightning_timer_timeout():
	if level >= 1:
		var enemy_array = get_tree().get_nodes_in_group("enemy")
		if enemy_array.size() > 0:
			shoot_lightning(enemy_array)


func _on_collectionbox_area_entered(hitbox):
	receive_xp(hitbox)


func receive_xp(hitbox):
	#checks if the collected item is in the xp group (honestly should always be
	#becaue of collision layers but just to make sure)
	if hitbox.is_in_group("xp"):
		#deletes the node from the tree
		hitbox.queue_free()
		#increases xp
		xp += 1
		print(xp)
		#checks if ready to level up
		if xp == xp_max:
			level_up()


func level_up():
	#increases level
	level += 1
	xp = 0
	xp_max += 5
	print("LEVEL UP!")
	
