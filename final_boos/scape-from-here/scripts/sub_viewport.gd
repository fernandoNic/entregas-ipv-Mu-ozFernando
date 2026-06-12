extends SubViewport

@onready var character_body_2d: CharacterBody2D = $"../../../../World/Player/CharacterBody2D"
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	var level = get_tree().root
	var mundo_principal = level.get_node("Level").get_node("World") 
	
	world_2d = mundo_principal.get_world_2d()

func _process(_delta: float) -> void:
	if character_body_2d:
		camera_2d.global_position = character_body_2d.global_position
