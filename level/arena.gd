extends Node2D

var rng = RandomNumberGenerator.new()
var camera2d

var skeletons = preload("res://enemies/enemy.tscn")
var zombies = preload("res://enemies/zombie/zombie.tscn")
const x = 400
const y = 400

#var spawn_position = get_node("Player").position + Vector2(100, 0).rotated(rng.randf_range(0, 2*PI))

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	camera2d = get_node("Player/Camera2d")
	print(get_node("Player").position)
	print(get_node("Player").get_child(1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_skeleton_spawn_timer_timeout():
	var skeles = skeletons.instantiate()
	add_child(skeles)
	var center = camera2d.get_target_position()
	skeles.position = center
	var direction = rng.randi_range(0,3)
	if direction == 0: # up
		skeles.position.x += rng.randf_range(-x, x)
		skeles.position.y -= y
	elif direction == 1: # down
		skeles.position.x += rng.randf_range(-x, x)
		skeles.position.y += y
	elif direction == 2: # left
		skeles.position.x -= x
		skeles.position.y += rng.randf_range(-y, y)
	elif direction == 3: # right
		skeles.position.x += x
		skeles.position.y += rng.randf_range(-y, y)
	




func _on_zombie_spawn_timer_timeout():
	var zomb = zombies.instantiate()
	add_child(zomb)
	var center = camera2d.get_target_position()
	zomb.position = center
	var direction = rng.randi_range(0,3)
	if direction == 0: # up
		zomb.position.x += rng.randf_range(-x, x)
		zomb.position.y -= y
	elif direction == 1: # down
		zomb.position.x += rng.randf_range(-x, x)
		zomb.position.y += y
	elif direction == 2: # left
		zomb.position.x -= x
		zomb.position.y += rng.randf_range(-y, y)
	elif direction == 3: # right
		zomb.position.x += x
		zomb.position.y += rng.randf_range(-y, y)
	
