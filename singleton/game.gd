extends Node

@onready var players := {
	"1": {
		viewport = $Control/HBoxContainer/SubViewportContainer/SubViewport,
		camera = $Control/HBoxContainer/SubViewportContainer/SubViewport/Camera2D,
		player = $Control/HBoxContainer/SubViewportContainer/SubViewport/Arena/Player1,
		playerLevelText = $Control/HUDMargin/P1Level/P1LevelText,
		playerLevelXPBar = $Control/HUDMargin/P1Level/P1LevelXPBar,
	},
	"2": {
		viewport = $Control/HBoxContainer/SubViewportContainer2/SubViewport,
		camera = $Control/HBoxContainer/SubViewportContainer2/SubViewport/Camera2D,
		player = $Control/HBoxContainer/SubViewportContainer/SubViewport/Arena/Player2,
		playerLevelText = $Control/HUDMargin/P2Level/P2LevelText,
		playerLevelXPBar = $Control/HUDMargin/P2Level/P2LevelXPBar,
	}
}

func _ready() -> void:
	players["2"].viewport.get_viewport().world_2d = players["1"].viewport.get_viewport().world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
