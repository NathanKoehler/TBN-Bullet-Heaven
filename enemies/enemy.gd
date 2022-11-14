extends CharacterBody2D

var rng = RandomNumberGenerator.new()

var spawn_position

func _ready():
	pass


func _physics_process(delta):
	var player = get_parent().get_node("Player")
	position += (player.position - position).normalized() * 0.7
	



	
	
