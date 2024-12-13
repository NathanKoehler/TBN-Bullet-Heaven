extends Node
class_name MasterGame

@export var lives = 4

@onready var seperator := $Control/HUDMargin/PlayerSeperator

@onready var arena := $Control/ArenaSubViewport/Arena
@onready var pausemenu := $Control/PauseMenu

@onready var players1HUD := $Control/HUDMargin/PlayerSeperator/Player1HUD
@onready var players1SVP := $Control/MultiplayerSVPContainer/Player1SVPContainer/SubViewport
@onready var player1SVPC := $Control/MultiplayerSVPContainer/Player1SVPContainer

@onready var players2HUD := $Control/HUDMargin/PlayerSeperator/Player2HUD
@onready var players2SVP := $Control/MultiplayerSVPContainer/Player2SVPContainer/SubViewport
@onready var player2SVPC := $Control/MultiplayerSVPContainer/Player2SVPContainer

@onready var player1Shader := "res://menus/player/player1.gdshader"
@onready var player2Shader := "res://menus/player/player2.gdshader"


static var singleplayer = false;

@export var items_dict = {
	"Bone Tooth": {count = 0, texture = load("res://menus/UpgradeItems/Bonetooth.png"), description = "Slightly increases health of the hero"},
	"Bronze Plate": {count = 0, texture = load("res://menus/UpgradeItems/BronzePlate.png"), description = "Slightly increases defense of the hero"},
	"Crit Tooth": {count = 0, texture = load("res://menus/UpgradeItems/CritTooth.png"), description = "Greatly increases crit chance of the hero"},
	"Devil Spike": {count = 0, texture = load("res://menus/UpgradeItems/DevilSpike.png"), description = "Slightly crit chance and crit damage of the hero"},
	"Piercing Tooth": {count = 0, texture = load("res://menus/UpgradeItems/PiercingTooth.png"), description = "Adds a flat crit damage bonus to all attacks"},
	"Health": {count = 0, texture = load("res://menus/UpgradeItems/Health.png"), description = "Heals back 50 health points"},
	"Giant Tooth": {count = 0, texture = load("res://menus/UpgradeItems/GiantTooth.png"), description = "Increases health of the hero significantly"},
	"Ice Blast": {count = 1, texture = load("res://menus/UpgradeItems/IceBlast.png"), mod = 2.5, attk_speed = 1, speed_mod = 1.18, description = "Increases attack of Ice Blast"},
	"Speed": {count = 0, texture = load("res://menus/UpgradeItems/Speed.png"), description = "Increases movement speed of the hero"},
	"Horns": {count = 0, texture = load("res://menus/UpgradeItems/Horns.png"), description = "Slightly increases movement and attack speed of projectile attacks"},
	"Spike Skin": {count = 0, texture = load("res://menus/UpgradeItems/SpikeSkin.png"), description = "Damages enemies that touch you"},
	"Lightning": {count = 0, texture = load("res://menus/UpgradeItems/Lightning.png"), mod = 3, attk_speed = 3, speed_mod = 1.3, description = "Increases attack of Lightning"},
	"Grow Scales": {count = 0, texture = load("res://menus/UpgradeItems/GrowScales.png"), description = "Increases shield size of the hero"},
	"Scale Catalyst": {count = 0, texture = load("res://menus/UpgradeItems/ScaleCatalyst.png"), description = "Increases regeneration speed of the hero's shield"},
	"Ichor of Dionysus": {count = 0, texture = load("res://menus/UpgradeItems/IchorOfDionysus.png"), description = "Decreases time until recharge of hero's shield"},
	"Wind Slash": {count = 0, texture = load("res://menus/UpgradeItems/WindSlash.png"), mod = 2.3, attk_speed = 2, speed_mod = 1.15, description = "Increases attack of Wind Slash"},
	"Bone Caltraps": {count = 0, texture = load("res://menus/UpgradeItems/BoneCaltraps.png"), description = "Increases the attack speed of all attacks"},
	"Luck Leaf": {count = 0, texture = load("res://menus/UpgradeItems/LuckLeaf.png"), description = "Increases chance to negate damage"},
	"Second Wind": {count = 0, texture = load("res://menus/UpgradeItems/SecondWind.png"), description = "Adds a bonus life to the hero"},
	"Spike Circle": {count = 0, texture = load("res://menus/UpgradeItems/SpikeCircle.png"), description = "Slightly increases lifesteal and amount of life stolen per lifesteal"},
	"Ember Leaf": {count = 0, texture = load("res://menus/UpgradeItems/EmberLeaf.png"), description = "Attacks have a chance to burn enemies"},
	"Blood Leaf": {count = 0, texture = load("res://menus/UpgradeItems/BloodLeaf.png"), description = "Attacks have a chance to heal the hero - lifesteal"}
}


@onready var players := {
	"1": {
		hud = players1HUD,
		viewport = players1SVP,
		vpcontainer = player1SVPC,
		camera = players1SVP.get_node("Camera2D"),
		playerNode = arena.get_node("Multiplayer1"),
		levelText = players1HUD.get_node("P1Level/P1LevelText"),
		levelXPBar = players1HUD.get_node("P1Level/P1LevelXPBar"),
		upgradeMenu = players1HUD.get_node("P1UpgradeMenu"),
		items = items_dict.duplicate(true),
		lives = players1HUD.get_node("P1Lives"),
		shader = player1Shader,
		active = true,
	},
	"2": {
		hud = players2HUD,
		viewport = players2SVP,
		vpcontainer = player2SVPC,
		camera = players2SVP.get_node("Camera2D"),
		playerNode = arena.get_node("Multiplayer2"),
		levelText = players2HUD.get_node("P2Level/P2LevelText"),
		levelXPBar = players2HUD.get_node("P2Level/P2LevelXPBar"),
		upgradeMenu = players2HUD.get_node("P2UpgradeMenu"),
		items = items_dict.duplicate(true),
		lives = players2HUD.get_node("P2Lives"),
		shader = player2Shader,
		active = true,
	}
}

@onready var enemies := {}

func add_player(num):
	players[str(num)].active = true
	players[str(num)].playerNode.process_mode = 0
	players[str(num)].hud.process_mode = 0
	players[str(num)].vpcontainer.process_mode = 0

	players[str(num)].playerNode.show()
	players[str(num)].hud.show()
	players[str(num)].vpcontainer.show()


func remove_player(num):
	players[str(num)].active = false
	players[str(num)].playerNode.process_mode = 4
	players[str(num)].hud.process_mode = 4
	players[str(num)].vpcontainer.process_mode = 4

	players[str(num)].playerNode.hide()
	players[str(num)].hud.hide()
	players[str(num)].vpcontainer.hide()
	

func get_enemies():
	return enemies.values()

func add_enemy(enemy_id, enemy):
	enemies[enemy_id] = enemy

func remove_enemy(enemy_id):
	enemies.erase(enemy_id)

func get_arena():
	return arena

func get_player_list():
	return players.values().filter(func(player): return player.active) 

func get_player_prop(player_id, prop):
	return players[str(player_id)][prop]

func set_player_prop(player_id, prop, value):
	players[str(player_id)][prop] = value

func _process(_delta):
	pass
	

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if (singleplayer):
		remove_player(2)
		seperator.set_process(false)		
	
	var player_values = players.values()
	for i in player_values.size():
		var player = player_values[i]
		player.playerNode.id = i + 1
		player.viewport.get_viewport().world_2d = arena.get_world_2d()
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = player.camera.get_path()
		player.playerNode.add_child(remote_transform)
		player.playerNode.material.shader = load(player.shader)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if PauseMenu.paused:
			pausemenu.unpause()
		else:
			pausemenu.pause()
		
func decrease_lives() -> void:
	lives -= 1
	
	
	players["1"].lives.text = "Lives: " + str(lives)
	players["2"].lives.text = "Lives: " + str(lives)
	if lives == 0:
		get_tree().call_deferred("change_scene_to_file", "res://menus/MainMenu/DeathScreen.tscn")
		print("player has died")
		
# func level_text_update(id, level) -> void:
# 	var player_id = str(id)
# 	players[player_id].levelText.text = "Level: " + str(level)
