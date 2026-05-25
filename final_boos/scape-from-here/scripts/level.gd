extends Node2D

var keys: int = 5

func game_over() -> void:
	var canvas_layer: CanvasLayer = GameManager.obtener_canvas()
	canvas_layer.set_visible(true)
	var pause_node = canvas_layer.get_node("pause_menu")
	pause_node.queue_free()
	var overlay = canvas_layer.get_node("DarkOverlay")
	
	var tween = create_tween()
	tween.tween_property(overlay,"color:a",1,2.0)
	await tween.finished
	
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_character_body_2d_grab_keys() -> void:
	keys += 1
	if keys == 6:
		game_over()
