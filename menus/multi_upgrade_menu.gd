extends Control

signal upgrade(item)

@export var items = [
	{name = "Bone Tooth", count = 0, texture = load("res://menus/UpgradeItems/Bonetooth.png"), description = "Slightly increases health of the hero"},
	{name = "Bronze Plate", count = 0, texture = load("res://menus/UpgradeItems/BronzePlate.png"), description = "Slightly increases defense of the hero"},
	{name = "Crit Tooth", count = 0, texture = load("res://menus/UpgradeItems/CritTooth.png"), description = "Greatly increases crit chance of the hero"},
	{name = "Devil Spike", count = 0, texture = load("res://menus/UpgradeItems/DevilSpike.png"), description = "Slightly crit chance and crit damage of the hero"},
	{name = "Piercing Tooth", count = 0, texture = load("res://menus/UpgradeItems/PiercingTooth.png"), description = "Adds a flat crit damage bonus to all attacks"},
	{name = "Health", count = 0, texture = load("res://menus/UpgradeItems/Health.png"), description = "Heals back 50 health points"},
	{name = "Giant Tooth", count = 0, texture = load("res://menus/UpgradeItems/GiantTooth.png"), description = "Increases health of the hero significantly"},
	{name = "Ice Blast", count = 1, texture = load("res://menus/UpgradeItems/IceBlast.png"), mod = 2.5, attk_speed = 1, speed_mod = 1.18, description = "Increases attack of Ice Blast"},
	{name = "Speed", count = 0, texture = load("res://menus/UpgradeItems/Speed.png"), description = "Increases movement speed of the hero"},
	{name = "Horns", count = 0, texture = load("res://menus/UpgradeItems/Horns.png"), description = "Slightly increases movement and attack speed of projectile attacks"},
	{name = "Spike Skin", count = 0, texture = load("res://menus/UpgradeItems/SpikeSkin.png"), description = "Damages enemies that touch you"},
	{name = "Lightning", count = 0, texture = load("res://menus/UpgradeItems/Lightning.png"), mod = 3, attk_speed = 3, speed_mod = 1.3,  description = "Increases attack of Lightning"},
	{name = "Grow Scales", count = 0, texture = load("res://menus/UpgradeItems/GrowScales.png"), description = "Increases shield size of the hero"},
	{name = "Scale Catalyst", count = 0, texture = load("res://menus/UpgradeItems/ScaleCatalyst.png"), description = "Increases regeneration speed of the hero's shield"},
	{name = "Ichor of Dionysus", count = 0, texture = load("res://menus/UpgradeItems/IchorOfDionysus.png"), description = "Decreases time until recharge of hero's shield"},
	{name = "Wind Slash", count = 0, texture = load("res://menus/UpgradeItems/WindSlash.png"), mod = 2.3, attk_speed = 2, speed_mod = 1.15,  description = "Increases attack of Wind Slash"},
	{name = "Bone Caltraps", count = 0, texture = load("res://menus/UpgradeItems/BoneCaltraps.png"), description = "Increases the attack speed of all attacks"},
	{name = "Luck Leaf", count = 0, texture = load("res://menus/UpgradeItems/LuckLeaf.png"), description = "Increases chance to negate damage"},
	{name = "Second Wind", count = 0, texture = load("res://menus/UpgradeItems/SecondWind.png"), description = "Adds a bonus life to the hero"},
	{name = "Spike Circle", count = 0, texture = load("res://menus/UpgradeItems/SpikeCircle.png"), description = "Slightly increases lifesteal and amount of life stolen per lifesteal"},
	{name = "Ember Leaf", count = 0, texture = load("res://menus/UpgradeItems/EmberLeaf.png"), description = "Attacks have a chance to burn enemies"},
	{name = "Blood Leaf", count = 0, texture = load("res://menus/UpgradeItems/BloodLeaf.png"), description = "Attacks have a chance to heal the hero - lifesteal"},
]

var offered = []

var paused = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
	for item in items:
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
	var rand_dict = run_randomizer(items.size())
	var loaded = 0
	offered.clear()
	for num in rand_dict:
		print(num)
		offered.append(items[num])
		var item = $HBoxContainer/Items.get_child(loaded)
		print_debug(item)
		item.get_child(0).texture = offered[loaded].texture
		item.get_child(1).get_child(0).text = offered[loaded].name
		item.get_child(1).get_child(1).text = offered[loaded].description
		loaded += 1

	
