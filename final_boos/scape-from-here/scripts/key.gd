extends Area2D

@onready var icon: Sprite2D = $icon

func _ready() -> void:
	GameManager.minimap_show.connect(show_on_minimap)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		queue_free()
		body.grab_a_key()

func show_on_minimap() -> void:
	icon.visible = !icon.visible
