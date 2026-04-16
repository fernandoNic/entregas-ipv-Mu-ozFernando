extends Node

@onready var player: Node2D = $Player
@onready var turret_spawner: Node = $TurretsSpawner

func _ready() -> void:
	randomize()
	player.initialize(self)
	turret_spawner.initialize(player)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()
