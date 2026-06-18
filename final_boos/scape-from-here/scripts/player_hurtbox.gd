extends Area2D
@onready var player: CharacterBody2D = get_parent() as CharacterBody2D

func take_damage(enemy_damage :int,enemy_position :Vector2) -> void:
	player.receive_damage(enemy_damage,enemy_position)
