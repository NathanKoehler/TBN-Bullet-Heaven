extends CharacterBody2D

@export var controls: Resource = null

signal hp_changed(new_hp)
signal died

const LEFT = -1
const RIGHT = 1
const UP = -1
const DOWN = 1


var shootX = 0
var shootY = 0
var is_using_controller = false

@export var id = -1

@onready var shieldBar = $PlayerShieldBar
@onready var healthBar = $PlayerHealthBar

@export var speed = 100 : 
	set(value):
		speed = value 
	get:
		return speed
@export var currPosition = position
@export var hp_max = 100: 
	set(value):
		if value != hp_max:
			hp_max = max(0, value)
			healthBar.max_value = hp_max
			healthBar.get_child(0).text = str(round(hp)) + " / " + str(hp_max)
			self.hp = hp
	get:
		return hp_max
@export var hp = 100 : 
	set(value):
		if value != hp:
			hp = clamp(value, 0, hp_max)
			
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

var game_controller


# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	game_controller = root.get_child(root.get_child_count() - 1)
	
	if not controls:
		set_physics_process(false)
	
	rng.randomize()
	pause_menu.hide()

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
	
	var horizontal_shoot := Input.get_action_strength(controls.aim_right) - Input.get_action_strength(controls.aim_left)
	var vertical_shoot := Input.get_action_strength(controls.aim_up) - Input.get_action_strength(controls.aim_down)
	
	shootX = horizontal_shoot
	shootY = vertical_shoot
	
	#shooting controls
	if not is_using_controller:
		if horizontal_shoot != 0 and vertical_shoot != 0:
			is_using_controller = true
	else:
		if horizontal_shoot == 0 and vertical_shoot == 0:
			is_using_controller = false

	if horizontal_shoot > 0:
		shootX = RIGHT
	elif horizontal_shoot < 0:
		shootX = LEFT
	elif vertical_shoot != 0:
		shootX = 0
		
	if vertical_shoot > 0:
		shootY = UP
	elif vertical_shoot < 0:
		shootY = DOWN
	elif horizontal_shoot != 0:
		shootY = 0

#movement controls
	
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

func set_items(items):
	game_controller.set_player_prop(id, "items", items)


func get_items():
	return game_controller.get_player_prop(id, "items")

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
		if (get_items()["Second Wind"].count > 0):
			get_items()["Second Wind"].count = get_items()["Second Wind"].count - 1
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
		
	if get_items()["Luck Leaf"].count > 0:
		var rng = RandomNumberGenerator.new()
		var num = rng.randi_range(0, 100)
		if (num > get_items()["Luck Leaf"].count * 5):
			receive_damage(hitbox.damage)
	else:
		receive_damage(hitbox.damage)



func _on_player_died():
	hp += (hp_max/2)
	game_controller.decrease_lives()
	

func _on_dmg_timer_timeout():
	if (shield < shield_max and shield_max > 0):
		_shield_timer.start()
		
		
func _on_shield_timer_timeout():
	if (shield < shield_max):
		shield += shield_regen_rate
	else:
		_shield_timer.stop()

func find_closest_enemy():
	var enemy_array = game_controller.get_enemies()
	var closest_enemy = null
	var closest_distance = INF
	for enemy in enemy_array:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_enemy = enemy
			closest_distance = distance
	return closest_enemy

# spell functions
func shoot_magic_bullet():
	if magic_bullet:
		var nearest_enemy = find_closest_enemy()
		
		if nearest_enemy:
			var mb = magic_bullet.instantiate()
			
			mb.damage = mod_weapon_damage("Ice Blast", mb)
			mb.speed = mod_weapon_speed("Ice Blast", mb.speed)
			get_tree().current_scene.get_node("Control/ArenaSubViewport/Arena").add_child(mb)
			mb.set_position(global_position)
			
			if is_using_controller:
				mb.set_rotation(atan2(shootY, shootX))
			else:
				var lookat_pos = find_closest_enemy().global_position - global_position
				mb.set_rotation(atan2(lookat_pos.y, lookat_pos.x))

func _on_magic_bullet_timer_timeout():
	shoot_magic_bullet()

func spawn_effect(EFFECT: PackedScene, effect_pos: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.get_node("Control/ArenaSubViewport/Arena").add_child(effect)
		effect.set_position(effect_pos)

func shoot_lightning(enemy_array):
	if lightning:
		for enemy in enemy_array:
			if enemy.get_node("notifier") != null and enemy.get_node("notifier").is_on_screen():
				var bolt = lightning.instantiate()
				bolt.damage = mod_weapon_damage("Lightning", bolt)
				get_tree().current_scene.get_node("Control/ArenaSubViewport/Arena").add_child(bolt)
				bolt.set_position(enemy.get_global_position())
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
		get_tree().current_scene.get_node("Control/ArenaSubViewport/Arena").add_child(ws)
		#add_child(mb)
		ws.damage = mod_weapon_damage("Wind Slash", ws)
		ws.speed = mod_weapon_speed("Wind Slash", ws.speed)
		ws.set_position(global_position)
		if is_using_controller:
			ws.set_rotation(atan2(shootY, shootX))
		else:
			var lookat_pos = find_closest_enemy().global_position - global_position
			ws.set_rotation(atan2(lookat_pos.y, lookat_pos.x))

	
func mod_weapon_damage(name: String, weapon):
	var new_damage = weapon.damage
	if get_items()[name].count > 0:
		new_damage += get_items()[name].count * get_items()[name].mod
	
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
	new_speed += get_items()["Horns"].count * get_items()[name].speed_mod * 2
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
		game_controller.get_player_prop(id, "levelXPBar").value = xp
		print(xp)
		#checks if ready to level up
		if xp == xp_max:
			level_up()


func level_up():
	#increases level
	level += 1
	xp = 0
	xp_max += 2
	print("LEVEL UP!")
	game_controller.get_player_prop(id, "levelXPBar").max_value = xp_max
	game_controller.get_player_prop(id, "levelXPBar").value = xp
	game_controller.get_player_prop(id, "levelText").text = "Level: " + str(level)
	game_controller.get_player_prop(id, "upgradeMenu").open(id, level)
	

	
	

func lifesteal(amount: float):
	if (randi_range(0, 100) < lifesteal_chance):
		health_boost(amount * lifesteal_mod)

func health_boost(amount: float):
	hp += ceil(amount)
	
func improve_weapon(name, item):
	print("Upgraded weapon: " + name)
	
func improve_attack_speeds(amount: int, type: int = 0):
	match(type):
		0:
			attack_speed += amount
		1:
			proj_attack_speed += amount
		_:
			pass
	if get_items()["Wind Slash"].count > 0:
		$wind_slash_timer.wait_time = (get_items()["Wind Slash"].attk_speed 
		* pow(get_items()["Wind Slash"].speed_mod, -0.5 * (attack_speed + proj_attack_speed)))
		print("New Wind Slash attack speed: " + str($wind_slash_timer.wait_time))
	if get_items()["Lightning"].count > 0:
		$lightning_timer.wait_time = (get_items()["Lightning"].attk_speed 
		* pow(get_items()["Lightning"].speed_mod, -0.5 * attack_speed))
		print("New Lightning attack speed: " + str($lightning_timer.wait_time))
	if get_items()["Ice Blast"].count > 0:
		$magic_bullet_timer.wait_time = (get_items()["Ice Blast"].attk_speed 
		* pow(get_items()["Ice Blast"].speed_mod, -0.5 * (attack_speed + proj_attack_speed)))
		print("New Ice Blast attack speed: " + str($magic_bullet_timer.wait_time))

func handle_upgrade(name, item):
	get_items()[name] = item
	print("recieved a " + name)
	match (name):
		"Health":
			health_boost(50)
		"Lightning":
			if !lightning_enabled:
				lightning_enabled = true
			else: 
				improve_weapon(name, item)
		"Ice Blast":
			improve_weapon(name, item)
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
			spikeskin_damage += 1 + 4 * get_items()[name].count
		"Scale Catalyst":
			shield_regen_rate = log(get_items()[name].count + 1) * 10 + get_items()[name].count/5
		"Ichor of Dionysus":
			shield_regen_delay = max(4 - pow(2, 2 - get_items()[name].count / 4), 1)
		"Grow Scales":
			shield_max += 20
		"Wind Slash":
			if !windslash_enabled:
				windslash_enabled = true
			else: 
				improve_weapon(name, item)
		"Spike Circle":
			lifesteal_chance += 5
			lifesteal_mod += 0.1
		"Blood Leaf":
			lifesteal_chance += 10
		_:
			hp -= 2




