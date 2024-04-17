extends CharacterBody2D

@export var controls: Resource = null

signal hp_changed(new_hp)
signal died

const LEFT = -1
const RIGHT = 1
const UP = -1
const DOWN = 1

var lookX = RIGHT;
var lookY = 0;
@onready var shieldBar = $PlayerShieldBar
@onready var healthBar = $PlayerHealthBar
@onready var upgradeMenu = $UpgradeMenu
@onready var playerLevelBar = $UpgradeMenu/LevelBarHolder/PlayerLevelBar
@export var speed = 100 : 
	set(value):
		speed = value 
	get:
		return speed
@export var currPosition = position
@export var hp_max = 5 : 
	set(value):
		if value != hp_max:
			hp_max = max(0, value)
			emit_signal("hp_max_changed", hp_max)
			healthBar.max_value = hp_max
			healthBar.get_child(0).text = str(round(hp)) + " / " + str(hp_max)
			self.hp = hp
	get:
		return hp_max
@export var hp = 100 : 
	set(value):
		if value != hp:
			hp = clamp(value, 0, hp_max)
			emit_signal("hp_changed", hp)
			
			_dmg_timer.start()
			
			healthBar.value = hp
			healthBar.get_child(0).text = str(round(hp)) + " / " + str(hp_max)
			if hp != hp_max:
				healthBar.show()
	get:
		return hp

@export var shield_regen_rate = 4
@export var shield_regen_delay = 5
@export var shield_max = 0:
	set(value):
		if shield_max != 0:
			shieldBar.show()
		if value != shield_max:
			shield_max = max(0, value)
			emit_signal("shield_max_changed", shield_max)
			
			_dmg_timer.set_wait_time(shield_regen_delay)
			if _shield_timer.time_left == 0:
				_shield_timer.start()
			
			shieldBar.max_value = shield_max
			shieldBar.get_child(0).text = str(round(shield)) + " / " + str(shield_max)
			self.shield = shield
	get:
		return shield_max

@export var shield = 0:
	set(value):
		if value != shield:
			shield = clamp(value, 0, shield_max)
			emit_signal("shield_changed", shield)
			shieldBar.value = shield
			shieldBar.get_child(0).text = str(round(shield)) + " / " + str(shield_max)
			
			_dmg_timer.start()
			
			if shield == 0:
				emit_signal("shield_break")
			elif shield != shield_max:
				shieldBar.show()
	get:
		return shield

@export var defense = 0 : 
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
@export var xp_max = 1

@export var crit_bonus = 0
@export var crit_chance = 0
@export var crit_mod = 1.5
@export var attack_speed = 0
@export var proj_attack_speed = 0
@export var lifesteal_chance = 0
@export var lifesteal_mod = 0.5

# Skill enablers
var lightning_enabled = false
var spikeskin_enabled = false
var spikeskin_damage = 0
var windslash_enabled = false
@onready var item_array = $UpgradeMenu.items
@onready var item_dict = {}

# Scene references
@export var effect_hit = preload("res://effects/hit_effect.tscn")
@export var effect_death = preload("res://effects/death_effect.tscn")
@export var magic_bullet = preload("res://menus/player/player_spells/magic_bullet/magic_bullet.tscn")
@export var lightning = preload("res://menus/player/player_spells/lightning/lightning.tscn")
@export var wind_slash = preload("res://menus/player/player_spells/wind_slash/wind_slash.tscn")

# Node references
@onready var pause_menu = $PauseMenu
@onready var upgrade_menu = $UpgradeMenu

# general vars
var rng = RandomNumberGenerator.new()
var is_paused = false

var _dmg_timer := Timer.new()
var _shield_timer := Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if not controls:
		set_physics_process(false)
	
	rng.randomize()
	pause_menu.hide()
	
	for item in item_array:
		item_dict[item.name] = item
	
	add_child(_dmg_timer)
	_dmg_timer.connect("timeout", Callable(self, "_on_dmg_timer_timeout"))
	
	add_child(_shield_timer)
	_shield_timer.connect("timeout", Callable(self, "_on_shield_timer_timeout"))
	_shield_timer.set_wait_time(0.2)
	_shield_timer.set_one_shot(false) # Make sure it loops
	
	

#func _process(delta):
	#$ShotPosition.set_position(Vector2(lookX, lookY))
	
	
func _physics_process(delta: float) -> void:
	velocity = Vector2()
	
	var horizontal_dir := Input.get_action_strength(controls.move_right) - Input.get_action_strength(controls.move_left)
	var vertical_dir := Input.get_action_strength(controls.move_down) - Input.get_action_strength(controls.move_up)

	if horizontal_dir > 0:
		lookX = RIGHT
	elif horizontal_dir < 0:
		lookX = LEFT
	elif vertical_dir != 0:
		lookX = 0
		
	if vertical_dir > 0:
		lookY = DOWN
	elif vertical_dir < 0:
		lookY = UP
	elif horizontal_dir != 0:
		lookY = 0
	
	velocity.x = horizontal_dir * speed
	velocity.y = vertical_dir * speed
		
	if Input.is_key_pressed(KEY_ESCAPE): #Controls the pause menu
		if is_paused == false:
			is_paused = true
			pause_menu.pause()
		else:
			is_paused = false
			pause_menu.unpause()
	
	
	
	velocity.normalized()
	move_and_slide()

#func get_position():
	#return position


func receive_damage(base_damage):
	var actual_damage = base_damage
	actual_damage = clamp(actual_damage - defense, 0, actual_damage)
	if shield > 0:
		shield -= actual_damage
		if shield < 0:
			hp += shield
			shield = 0
	else:
		hp -= actual_damage
	if hp <= 0:
		if "Second Wind" in item_dict:
			if (item_dict["Second Wind"].count > 0):
				item_dict["Second Wind"].count = item_dict["Second Wind"].count - 1
				hp = max(100, hp_max)
	if hp == 0:
		emit_signal("died")
	print(hp)
	print(str(name) + " with " + str(defense) + " defense received " + str(actual_damage) + " damage")

func _on_hurtbox_area_entered(hitbox):
	if hitbox.is_in_group("enemy") and spikeskin_enabled:
		var enemy = hitbox.get_parent()
		var actual_damage = enemy.receive_damage(spikeskin_damage)
		enemy.receive_knockback(hitbox.global_position, actual_damage)
		enemy.spawn_effect(effect_hit)
		enemy.spawn_dmg_indicator(actual_damage, false)
		
	if "Luck Leaf" in item_dict:
		var rng = RandomNumberGenerator.new()
		var num = rng.randi_range(0, 100)
		if (num > item_dict["Luck Leaf"].count * 5):
			receive_damage(hitbox.damage)
	else:
		receive_damage(hitbox.damage)



func _on_player_died():
	get_tree().change_scene_to_file("res://menus/MainMenu/DeathScreen.tscn")
	print("player has died")
	

func _on_dmg_timer_timeout():
	if (shield < shield_max and shield_max > 0):
		_shield_timer.start()
		
		
func _on_shield_timer_timeout():
	if (shield < shield_max):
		shield += shield_regen_rate
	else:
		_shield_timer.stop()

# spell functions
func shoot_magic_bullet():
	if magic_bullet:
		var mb = magic_bullet.instantiate()
		
		mb.damage = mod_weapon_damage("Ice Blast", mb)
		mb.speed = mod_weapon_speed("Ice Blast", mb.speed)
		get_tree().current_scene.get_node("Control/ArenaSubViewport/Arena").add_child(mb)
		mb.set_position($".".get_global_position())

		mb.set_rotation(atan2(lookY, lookX))

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
			if enemy.get_node("notifier") != null and enemy.get_node("notifier").is_on_screen():
				var bolt = lightning.instantiate()
				bolt.damage = mod_weapon_damage("Lightning", bolt)
				get_tree().current_scene.add_child(bolt)
				bolt.global_position = enemy.global_position
				break

func _on_lightning_timer_timeout():
	if lightning_enabled:
		var enemy_array = get_tree().get_nodes_in_group("enemy")
		if enemy_array.size() > 0:
			shoot_lightning(enemy_array)

func _on_wind_slash_timer_timeout():
	if windslash_enabled:
		print("enabled")
		var ws = wind_slash.instantiate()
		get_tree().current_scene.add_child(ws)
		#add_child(mb)
		ws.damage = mod_weapon_damage("Wind Slash", ws)
		ws.speed = mod_weapon_speed("Wind Slash", ws.speed)
		ws.position = $ShotPosition/Marker2d.global_position
		
		
		var ws_rotation = $ShotPosition.global_position.direction_to(get_global_mouse_position()).angle()
		ws.rotation = ws_rotation
		ws.look_at(get_global_mouse_position())
	
func mod_weapon_damage(name: String, weapon):
	var new_damage = weapon.damage
	if name in item_dict:
		new_damage += item_dict[name].count * item_dict[name].mod
	
	if (crit_chance > 100 and crit_chance >= rng.randi_range(0, 200)):
		new_damage = new_damage * crit_mod * 4 + crit_bonus
		weapon.is_crit = true
	elif (crit_chance >= rng.randi_range(0, 100)):
		new_damage = new_damage * crit_mod + crit_bonus
		weapon.is_crit = true
	weapon.scale[0] = (new_damage - weapon.damage) / 18 + weapon.scale[0]
	weapon.scale[1] = (new_damage - weapon.damage) / 18 + weapon.scale[1]
	return new_damage
	
func mod_weapon_speed(name: String, speed: float):
	var new_speed = speed
	if "Horns" in item_dict:
		new_speed += item_dict["Horns"].count * item_dict[name].speed_mod * 2
	return new_speed
	
func _on_collectionbox_area_entered(hitbox):
	receive_xp(hitbox)


func receive_xp(hitbox):
	#checks if the collected item is in the xp group (honestly should always be
	#because of collision layers but just to make sure)
	if hitbox.is_in_group("xp"):
		#deletes the node from the tree
		hitbox.queue_free()
		#increases xp
		xp += 1
		playerLevelBar.value = xp
		print(xp)
		#checks if ready to level up
		if xp == xp_max:
			level_up()


func level_up():
	#increases level
	level += 1
	xp = 0
	xp_max += 2
	playerLevelBar.max_value = xp_max
	playerLevelBar.value = xp
	print("LEVEL UP!")

	$UpgradeMenu.open(level)
	
	

func lifesteal(amount: float):
	if (randi_range(0, 100) < lifesteal_chance):
		health_boost(amount * lifesteal_mod)

func health_boost(amount: float):
	hp += ceil(amount)
	
func improve_weapon(item):
	print("Upgraded weapon: " + item.name)
	
func improve_attack_speeds(amount: int, type: int = 0):
	match(type):
		0:
			attack_speed += amount
		1:
			proj_attack_speed += amount
		_:
			pass
	if "Wind Slash" in item_dict:
		$wind_slash_timer.wait_time = (item_dict["Wind Slash"].attk_speed 
		* pow(item_dict["Wind Slash"].speed_mod, -0.5 * (attack_speed + proj_attack_speed)))
		print("New Wind Slash attack speed: " + str($wind_slash_timer.wait_time))
	if "Lightning" in item_dict:
		$lightning_timer.wait_time = (item_dict["Lightning"].attk_speed 
		* pow(item_dict["Lightning"].speed_mod, -0.5 * attack_speed))
		print("New Lightning attack speed: " + str($lightning_timer.wait_time))
	if "Ice Blast" in item_dict:
		$magic_bullet_timer.wait_time = (item_dict["Ice Blast"].attk_speed 
		* pow(item_dict["Ice Blast"].speed_mod, -0.5 * (attack_speed + proj_attack_speed)))
		print("New Ice Blast attack speed: " + str($magic_bullet_timer.wait_time))

func _on_upgrade_menu_upgrade(item):
	item_dict[item.name] = item
	print("recieved a " + item.name)
	match (item.name):
		"Health":
			health_boost(50)
		"Lightning":
			if !lightning_enabled:
				lightning_enabled = true
			else: 
				improve_weapon(item)
		"Ice Blast":
			improve_weapon(item)
		"Speed":
			speed *= 1.5
		"Bronze Plate":
			defense += 1
		"Bone Tooth":
			hp_max += 50
		"Giant Tooth":
			hp_max += 150
		"Crit Tooth":
			crit_chance += 10
		"Devil Spike":
			crit_chance += 5
			crit_mod += 0.5
		"Piercing Tooth":
			crit_bonus += 5
		"Bone Caltraps":
			improve_attack_speeds(1)
		"Horns":
			improve_attack_speeds(1, 1)
		"Spike Skin":
			if !spikeskin_enabled:
				spikeskin_enabled = true
			spikeskin_damage += 1 + 4 * item_dict[item.name].count
		"Scale Catalyst":
			shield_regen_rate = log(item_dict[item.name].count + 1) * 10 + item_dict[item.name].count/5
		"Ichor of Dionysus":
			shield_regen_delay = max(4 - pow(2, 2 - item_dict[item.name].count / 4), 1)
		"Grow Scales":
			shield_max += 20
		"Wind Slash":
			if !windslash_enabled:
				windslash_enabled = true
			else: 
				improve_weapon(item)
		"Spike Circle":
			lifesteal_chance += 5
			lifesteal_mod += 0.1
		"Blood Leaf":
			lifesteal_chance += 10
		_:
			hp -= 2




