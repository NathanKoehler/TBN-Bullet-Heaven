extends Control

signal upgrade(item)

var offered = []

var paused = 0

var game_controller

var player_id

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	game_controller = root.get_child(root.get_child_count() - 1)
	$HBoxContainer.hide()
	$ExampleHBoxContainer.hide()
	add_item_to_list(game_controller.items_dict)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if paused == 1:
		get_tree().paused = true
	elif paused == 2:
		get_tree().paused = false
		paused = 0

func add_item_to_list(item_dict):
	print("adding item to player", player_id)
	for child in $ItemHBoxContainer.get_children():
		child.queue_free()
	
	for item in item_dict.values():
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
	item.value.count = item.value.count + 1
	game_controller.get_player_prop(player_id, "playerNode").handle_upgrade(item.name, item.value)
	add_item_to_list(game_controller.get_player_prop(player_id, "items"))
	print("player ", player_id)
	player_id = null
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
	
func open(playerId, level):
	player_id = playerId
	
	$HBoxContainer.show()
	paused = 1
	
	$HBoxContainer/Items/Item1.grab_focus()
	var rand_dict = run_randomizer(game_controller.items_dict.size())
	var loaded = 0
	offered.clear()
	var item_key_list = game_controller.items_dict.keys()
	for num in rand_dict:
		var item = game_controller.items_dict[item_key_list[num]]
		offered.append({"name": item_key_list[num], "value": game_controller.get_player_prop(player_id, "items")[item_key_list[num]] })
		var ui_item = $HBoxContainer/Items.get_child(loaded)
		ui_item.get_child(0).texture = item["texture"]
		ui_item.get_child(1).get_child(0).text = item_key_list[num]
		ui_item.get_child(1).get_child(1).text = item["description"]
		loaded += 1
