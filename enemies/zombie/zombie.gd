extends CharacterBody2D


@export var hp = 20
@export var hp_max = 20
@export var defense = 0
@export var level = 0
@export var speed = .5
@export var receives_knockback = true
@export var knockback_modifier = 1


#Scene references
@export var effect_hit = preload("res://effects/hit_effect.tscn")
@export var effect_death = preload("res://effects/death_effect.tscn")


var rng = RandomNumberGenerator.new()
var spawn_position

func _ready():
	pass


func die():
	spawn_effect(effect_death)
	queue_free()


func _physics_process(delta):
	var player = get_parent().get_node("Player")
	if player.hp > 0:
		position += (player.position - position).normalized() * speed
	

func receive_damage(base_damage):
	
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
	print("hit")
	var actual_damage = receive_damage(hitbox.damage)
	
	
	if hitbox.is_in_group("Projectile"):
		hitbox.destroy()
		
	receive_knockback(hitbox.global_position, actual_damage)
	spawn_effect(effect_hit)
	
	
func spawn_effect(EFFECT: PackedScene, effect_pos: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_pos



