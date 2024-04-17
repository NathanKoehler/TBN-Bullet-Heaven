extends Enemy


@onready var enemy_properties = {
	"hp": 20,
	"hp_max": 20,
	"defense": 0,
	"level": 0,
	"speed": .5,
	"receives_knockback": true,
	"knockback_modifier": 1
}

func _ready():
	for key in enemy_properties:
		self[key] = enemy_properties[key]

	print(effect_hit)
	print(effect_death)

	super()
