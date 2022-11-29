extends CharacterBody2D


@export var hp = 10
@export var hp_max = 10
@export var defense = 0
@export var level = 0
@export var speed = .7


var rng = RandomNumberGenerator.new()
var spawn_position

func _ready():
	pass


func _physics_process(delta):
	var player = get_parent().get_node("Player")
	position += (player.position - position).normalized() * speed


func _on_hurtbox_area_entered(hitbox):
	var base_damage = hitbox.damage
	self.hp -= base_damage
	
