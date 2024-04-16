extends Node2D

# References Library

var skeletons = preload("res://enemies/enemy.tscn")
var zombies = preload("res://enemies/zombie/zombie.tscn")


var rng = RandomNumberGenerator.new()
var player

const x_spawn_distance = 800
const y_spawn_distance = 600


func _ready():
	rng.randomize()
	player = get_node("Multiplayer1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_skeleton_spawn_timer_timeout():
	var skeles = skeletons.instantiate()
	add_child(skeles)
	var center = player.get_position()
	skeles.position = center
	var direction = rng.randi_range(0,3)
	if direction == 0: # up
		skeles.position.x += rng.randf_range(-x_spawn_distance, x_spawn_distance)
		skeles.position.y -= y_spawn_distance
	elif direction == 1: # down
		skeles.position.x += rng.randf_range(-x_spawn_distance, x_spawn_distance)
		skeles.position.y += y_spawn_distance
	elif direction == 2: # left
		skeles.position.x -= x_spawn_distance
		skeles.position.y += rng.randf_range(-y_spawn_distance, y_spawn_distance)
	elif direction == 3: # right
		skeles.position.x += x_spawn_distance
		skeles.position.y += rng.randf_range(-y_spawn_distance, y_spawn_distance)
	




func _on_zombie_spawn_timer_timeout():
	var zomb = zombies.instantiate()
	add_child(zomb)
	var center = player.get_position()
	zomb.position = center
	var direction = rng.randi_range(0,3)
	if direction == 0: # up
		zomb.position.x += rng.randf_range(-x_spawn_distance, x_spawn_distance)
		zomb.position.y -= y_spawn_distance
	elif direction == 1: # down
		zomb.position.x += rng.randf_range(-x_spawn_distance, x_spawn_distance)
		zomb.position.y += y_spawn_distance
	elif direction == 2: # left
		zomb.position.x -= x_spawn_distance
		zomb.position.y += rng.randf_range(-y_spawn_distance, y_spawn_distance)
	elif direction == 3: # right
		zomb.position.x += x_spawn_distance
		zomb.position.y += rng.randf_range(-y_spawn_distance, y_spawn_distance)
	
