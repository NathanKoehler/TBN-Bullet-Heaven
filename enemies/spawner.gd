extends Node2D
#var rng = RandomNumberGenerator.new()
#
#func spawn():
#	var enemy = load("res://enemies/enemy.tscn").instantiate()
#	add_child(enemy)
#	#print(get_parent().get_node("Player").position)
#	enemy.position = get_parent().get_node("Player").position +  Vector2(1000, 0).rotated(rng.randf_range(0, 2*PI))
#
#func _process(delta):
#	spawn()
