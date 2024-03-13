extends CharacterBody2D


@export var hp = 10
@export var hp_max = 10
@export var defense = 0
@export var level = 0
@export var speed = .5
@export var receives_knockback = true
@export var knockback_modifier = 1


#Scene references
@export var effect_hit = preload("res://effects/hit_effect.tscn")
@export var effect_death = preload("res://effects/death_effect.tscn")
@export var xp = preload("res://xp/xp.tscn")

@export var indicator_damage = preload("res://effects/damage_indicator.tscn")

#Node references
@onready var hitflash = $AnimationPlayer


var rng = RandomNumberGenerator.new()
var spawn_position

func _ready():
	pass


func die():
	drop_xp()
	spawn_effect(effect_death)
	queue_free()


func _physics_process(delta):
	var player = get_parent().get_node("Player")
	if player.hp > 0:
		position += (player.position - position).normalized() * speed
	

func receive_damage(base_damage):
	hitflash.play("hitflash")
	var actual_damage = base_damage
	#subtracts dmg from defense
	actual_damage -= defense
	#apply dmg to hp
	hp -= actual_damage
	#show hit effect and plays hit sound
	spawn_effect(effect_hit)
	SoundPlayer.play_enemyhitsound()
	#tracks if dead or not
	if hp <= 0:
		hp = 0
		die()
	print(str(name) + " received " + str(actual_damage) + " damage")
	return actual_damage


func receive_knockback(damage_source_pos: Vector2, received_damage: int):
	if receives_knockback:
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		var knockback_strength = received_damage * knockback_modifier
		var knockback = knockback_direction * knockback_strength
		
		global_position += knockback


func _on_hurtbox_area_entered(hitbox):
	var actual_damage = receive_damage(hitbox.damage)
	
	
	if hitbox.is_in_group("Projectile"):
		hitbox.destroy()
		
	if hitbox.is_crit:
		receive_knockback(hitbox.global_position, actual_damage + 2)
	else:
		receive_knockback(hitbox.global_position, actual_damage)
	spawn_effect(effect_hit)
	spawn_dmg_indicator(actual_damage, hitbox.is_crit)
	
	
func drop_xp():
	var xp_drop = xp.instantiate()
	get_tree().current_scene.call_deferred("add_child", xp_drop)
	xp_drop.call_deferred("set_global_position", self.global_position)
	
func spawn_effect(EFFECT: PackedScene, effect_pos: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_pos
		return effect
		
func spawn_dmg_indicator(damage: int, is_crit: bool = false):
	var indicator = spawn_effect(indicator_damage)
	if indicator:
		indicator.label.text = str(damage)
		if is_crit:
			indicator.label.self_modulate = '#E35335'
			indicator.label.scale[0] = 1.8
			indicator.label.scale[1] = 1.2
			
#func _on_hitbox_area_entered(hitbox):
#	if hitbox.is_in_group("Player"):
#		var player = hitbox.get_parent()
#		if player.spikeskin_enabled:
#			var actual_damage = receive_damage(player.spikeskin_damage)
#			receive_knockback(hitbox.global_position, actual_damage)
#			spawn_effect(effect_hit)
#			spawn_dmg_indicator(actual_damage, hitbox.is_crit)
#
