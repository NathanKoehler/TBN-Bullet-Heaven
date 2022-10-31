extends Node2D

var rng = RandomNumberGenerator.new()
var skeletons = preload("res://enemies/enemy.tscn")
#var spawn_position = get_node("Player").position + Vector2(100, 0).rotated(rng.randf_range(0, 2*PI))

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_node("Player").position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_spawn_timer_timeout():
	var instance = skeletons.instantiate()
	add_child(instance)
