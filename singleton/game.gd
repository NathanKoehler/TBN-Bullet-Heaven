extends Node

@onready var arena := $Control/ArenaSubViewport/Arena

@onready var player1HUD := $Control/HUDMargin/PlayerSeperator/Player1HUD
@onready var player1SVP := $Control/MultiplayerSVPContainer/Player1SVPContainer/SubViewport

@onready var player2HUD := $Control/HUDMargin/PlayerSeperator/Player2HUD
@onready var player2SVP := $Control/MultiplayerSVPContainer/Player2SVPContainer/SubViewport
=======
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