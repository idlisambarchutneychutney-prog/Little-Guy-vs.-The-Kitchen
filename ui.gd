extends Control

# Drag your Little Guy and Monster nodes into these slots in the Inspector
@export var player: CharacterBody2D
@export var monster: CharacterBody2D

@onready var player_health_label: Label = $PlayerHealthLabel
@onready var monster_health_label: Label = $MonsterHealthLabel


func _process(_delta: float) -> void:
	# Update Little Guy's health text
	if is_instance_valid(player) and "current_health" in player:
		player_health_label.text = "Little Guy HP: " + str(player.current_health) + " / " + str(player.max_health)
	else:
		player_health_label.text = "Little Guy HP: 0"

	# Update Marshmallow's health text
	if is_instance_valid(monster) and "current_health" in monster:
		monster_health_label.text = "Marshmallow HP: " + str(monster.current_health) + " / " + str(monster.max_health)
	else:
		monster_health_label.text = "Marshmallow HP: 0"
