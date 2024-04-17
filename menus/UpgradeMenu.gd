extends Control

signal upgrade(item)

var offered = []

var paused = 0

var game_controller

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	game_controller = root.get_child(root.get_child_count() - 1)
	$HBoxContainer.hide()
	add_item_to_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if paused == 1:
		get_tree().paused = true
	elif paused == 2:
		get_tree().paused = false
		paused = 0

func add_item_to_list():
	for child in $ItemHBoxContainer.get_children():
		child.queue_free()
	for item in game_controller.items:
		if (item.count > 1):
			var ui_elem = $ExampleHBoxContainer/ExampleGrid.duplicate()
			ui_elem.get_child(0).get_child(0).texture = item.texture
			ui_elem.get_child(0).get_child(1).texture = item.texture
			for x in range(2, item.count):
				ui_elem.get_child(0).add_child(ui_elem.get_child(0).get_child(0).duplicate())
			ui_elem.get_child(1).text = str(item.count)
			$ItemHBoxContainer.add_child(ui_elem)
		elif (item.count == 1):
			var ui_elem = $ExampleHBoxContainer/ExampleContainer.duplicate()
			ui_elem.get_child(0).texture = item.texture
			ui_elem.get_child(1).text = str(item.count)
			$ItemHBoxContainer.add_child(ui_elem)

func selected_upgrade(item):
	item.count = item.count + 1
	add_item_to_list()
	emit_signal("upgrade", item)
	close()

func _on_item_1_pressed():
	selected_upgrade(offered[0])


func _on_item_2_pressed():
	selected_upgrade(offered[1])
	

func _on_item_3_pressed():
	selected_upgrade(offered[2])

func run_randomizer(range):
	var rng = RandomNumberGenerator.new()
	var rand_dict = {}
	var count = range - 1
	var menu_items = 3
	for n in range(count - menu_items, count):
		var rand = rng.randi_range(0, n + 1)
		if (rand_dict.has(rand)):
			rand_dict[n] = true
		else:
			rand_dict[rand] = true
	return rand_dict
	
func close():
	paused = 2
	$HBoxContainer.hide()
	
func open(level):
	
	$HBoxContainer.show()
	$LevelText.text = "Level : " + str(level)
	paused = 1
	
	$HBoxContainer/Items/Item1.grab_focus()
	var rand_dict = run_randomizer(game_controller.items_dict.size())
	var loaded = 0
	offered.clear()
	var item_key_list = game_controller.items_dict.keys()
	for num in rand_dict:
		var item = item_key_list[num]
		offered.append(game_controller.items[num])
		var ui_item = $HBoxContainer/Items.get_child(loaded)
		ui_item.get_child(0).texture = item["texture"]
		ui_item.get_child(1).get_child(0).text = item["name"]
		ui_item.get_child(1).get_child(1).text = item["description"]
		loaded += 1

	
