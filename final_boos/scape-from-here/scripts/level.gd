extends Node2D

var keys: int

func _on_character_body_2d_grab_keys(cantidad: int) -> void:
	keys += 1
	print(cantidad)
