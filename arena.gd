extends Node2D

var rng = RandomNumberGenerator.new()
var camera2d
var instance
var skeletons = preload("res://enemies/enemy.tscn")
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



func _on_enemy_spawn_timer_timeout():
	instance = skeletons.instantiate()
	add_child(instance)
	var center = camera2d.get_target_position()
	instance.position = center
	var direction = rng.randi_range(0,3)
	if direction == 0: # up
		instance.position.x += rng.randf_range(-x, x)
		instance.position.y -= y
	elif direction == 1: # down
		instance.position.x += rng.randf_range(-x, x)
		instance.position.y += y
	elif direction == 2: # left
		instance.position.x -= x
		instance.position.y += rng.randf_range(-y, y)
	elif direction == 3: # right
		instance.position.x += x
		instance.position.y += rng.randf_range(-y, y)
	
