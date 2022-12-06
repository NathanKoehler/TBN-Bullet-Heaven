extends Node2D

@onready var enemyhitsound = get_node("AudioPlayers/EnemyHitSound")

func play_enemyhitsound():
	enemyhitsound.play()
