extends Node2D

var keys: int

func _on_character_body_2d_grab_keys(cantidad: int) -> void:
	keys += 1
	print(cantidad)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().call_deferred("reload_current_scene")
