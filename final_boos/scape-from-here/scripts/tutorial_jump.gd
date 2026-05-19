extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		visible = true


func _on_body_exited(_body: Node2D) -> void:
	visible = false
