extends Node

@onready var players := {
	"1": {
		viewport = $Control/HBoxContainer/SubViewportContainer/SubViewport,
		camera = $Control/HBoxContainer/SubViewportContainer/SubViewport/Camera2D,
		player = $Control/HBoxContainer/SubViewportContainer/SubViewport/Arena/Player1,
		levelText = $Control/HUDMargin/PlayerSeperator/Control/P1Level/P1LevelText,
		levelXPBar = $Control/HUDMargin/PlayerSeperator/Control/P1Level/P1LevelXPBar,
		upgradeMenu = $Control/HUDMargin/PlayerSeperator/Control/P1UpgradeMenu,
		itemBar = $Control/HUDMargin/PlayerSeperator/Control/P1ItemBar,
		items = items,
		lives = $Control/HUDMargin/PlayerSeperator/Control/P1Lives,
	},
	"2": {
		viewport = $Control/HBoxContainer/SubViewportContainer2/SubViewport,
		camera = $Control/HBoxContainer/SubViewportContainer2/SubViewport/Camera2D,
		player = $Control/HBoxContainer/SubViewportContainer/SubViewport/Arena/Player2,
		levelText = $Control/HUDMargin/PlayerSeperator/Control2/P2Level/P2LevelText,
		levelXPBar = $Control/HUDMargin/PlayerSeperator/Control2/P2Level/P2LevelXPBar,
		upgradeMenu = $Control/HUDMargin/PlayerSeperator/Control2/P2UpgradeMenu,
		itemBar = $Control/HUDMargin/PlayerSeperator/Control2/P2ItemBar,
		items = items,
	}
}

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

func _ready() -> void:
	players["2"].viewport.get_viewport().world_2d = players["1"].viewport.get_viewport().world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
		
		
