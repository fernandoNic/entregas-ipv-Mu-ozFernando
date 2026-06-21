extends Area2D

@onready var icon: Sprite2D = $icon

#func _ready() -> void:
	#GameManager.minimap_show.connect(show_on_minimap)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.grab_a_key()
		queue_free()

#func show_on_minimap() -> void:
	#icon.visible = !icon.visible
