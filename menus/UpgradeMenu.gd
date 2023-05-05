extends Control

signal upgrade(item)

@export var items = [
	{name = "Bone Tooth", count = 0, texture = load("res://menus/UpgradeItems/Bonetooth.png")},
	{name = "Bronze Plate", count = 0, texture = load("res://menus/UpgradeItems/BronzePlate.png")},
	{name = "Crit Tooth", count = 0, texture = load("res://menus/UpgradeItems/CritTooth.png")},
	{name = "Devil Spike", count = 0, texture = load("res://menus/UpgradeItems/DevilSpike.png")},
	{name = "Health", count = 0, texture = load("res://menus/UpgradeItems/Health.png")},
	{name = "Giant Tooth", count = 0, texture = load("res://menus/UpgradeItems/GiantTooth.png")},
	{name = "Ice Blast", count = 0, texture = load("res://menus/UpgradeItems/IceBlast.png")},
	{name = "Speed", count = 0, texture = load("res://menus/UpgradeItems/Speed.png")},
	{name = "Horns", count = 0, texture = load("res://menus/UpgradeItems/Horns.png")},
	{name = "Spike Skin", count = 0, texture = load("res://menus/UpgradeItems/SpikeSkin.png")},
	{name = "Lightning", count = 0, texture = load("res://menus/UpgradeItems/Lightning.png")}
]

var offered = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer.hide()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_item_to_list(item):
	var ui_element = TextureRect.new()
	ui_element.texture = item.texture
	$HBoxContainer2.add_child(ui_element)

func selected_upgrade(item):
	add_item_to_list(item)
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
	$HBoxContainer.hide()
	
func open(level):
	
	$HBoxContainer.show()
	$Text.text = "Level : " + str(level)
	# get_tree().paused = true
	$HBoxContainer/VBoxItemButtons/Item1.grab_focus()
	var rand_dict = run_randomizer(items.size())
	var loaded = 0
	offered.clear()
	for num in rand_dict:
		print(num)
		offered.append(items[num])
		$HBoxContainer/VBoxItemImages.get_child(loaded).texture = offered[loaded].texture
		$HBoxContainer/VBoxItemButtons.get_child(loaded).text = offered[loaded].name
		loaded += 1

func unpause():
	get_tree().paused = false
	
