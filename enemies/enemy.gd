extends CharacterBody2D


@export var hp = 10
@export var hp_max = 10
@export var defense = 0
@export var level = 0
@export var speed = .7
@export var receives_knockback = true
@export var knockback_modifier = 1


var rng = RandomNumberGenerator.new()
var spawn_position

func _ready():
	pass


func _physics_process(delta):
	var player = get_parent().get_node("Player")
	if player.hp > 0:
		position += (player.position - position).normalized() * speed

func receive_damage(base_damage):
	print(base_damage)
	var actual_damage = base_damage
	actual_damage -= defense
	hp -= actual_damage
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
		
	receive_knockback(hitbox.global_position, actual_damage)
	
