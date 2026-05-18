extends Area2D

@onready var v_box_container: Area2D = $"."

func _ready() -> void:
	visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		visible = true

func _on_body_exited(body: Node2D) -> void:
	visible = false
