extends CharacterBody2D

var rng = RandomNumberGenerator.new()

var spawn_position

func _ready():
	rng.randomize()
	if(spawn_position == null):
		print("hello")
	else:
		print(spawn_position)


func _physics_process(delta):
	var player = get_parent().get_node("Player")
	position += (player.position - position).normalized() * 0.7



func randomizeSpawn():
	print(spawn_position)
	position = spawn_position
	
	
