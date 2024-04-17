extends Node

@export var lives = 4

@onready var arena := $Control/ArenaSubViewport/Arena

@onready var players1HUD := $Control/HUDMargin/PlayerSeperator/Player1HUD
@onready var players1SVP := $Control/MultiplayerSVPContainer/Player1SVPContainer/SubViewport

@onready var players2HUD := $Control/HUDMargin/PlayerSeperator/Player2HUD
@onready var players2SVP := $Control/MultiplayerSVPContainer/Player2SVPContainer/SubViewport

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

@onready var players := {
	"1": {
		viewport = players1SVP,
		camera = players1SVP.get_node("Camera2D"),
		playerNode = arena.get_node("Multiplayer1"),
		levelText = players1HUD.get_node("P1Level/P1LevelText"),
		levelXPBar = players1HUD.get_node("P1Level/P1LevelXPBar"),
		upgradeMenu = players1HUD.get_node("P1UpgradeMenu"),
		itemBar = players1HUD.get_node("P1ItemBar"),
		items = items,
		active = true,
	},
	"2": {
		viewport = players2SVP,
		camera = players2SVP.get_node("Camera2D"),
		playerNode = arena.get_node("Multiplayer2"),
		levelText = players2HUD.get_node("P2Level/P2LevelText"),
		levelXPBar = players2HUD.get_node("P2Level/P2LevelXPBar"),
		upgradeMenu = players2HUD.get_node("P2UpgradeMenu"),
		itemBar = players2HUD.get_node("P2ItemBar"),
		items = items,
		active = true,
	}
}

func get_arena():
	return arena

func get_player_list():
	return players.values().filter(func(player): return player.active) 

func _ready() -> void:
	for player in players.values():
		player.viewport.get_viewport().world_2d = arena.get_world_2d()
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = player.camera.get_path()
		player.playerNode.add_child(remote_transform)
		
		
