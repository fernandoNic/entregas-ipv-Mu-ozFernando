extends Node2D

@onready var health_bar_canvas: CanvasLayer = $HUD/HealthBar
@onready var total_keys: CanvasLayer = $HUD/total_keys
@onready var view_map: CanvasLayer = $UI/view_map
@onready var character_body_2d: CharacterBody2D = $World/Player/CharacterBody2D

const MUNDO_ANCHO: float = 6980.0
const MUNDO_ALTO: float = 3900.0
const ORIGEN_X: float = -400.0
const ORIGEN_Y: float = -2000.0

var keys: int = 0

func _process(_delta: float) -> void:
	pass

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
	var label_keys: Label = total_keys.get_node_or_null("HBoxContainer/Label")
	label_keys.set_text(" x   " + str(keys))
	if keys == 4:
		game_over()


func _on_character_body_2d_player_death() -> void:
	game_over()


func _on_character_body_2d_live_changed(enemy_damaged: int) -> void:
	var health_bar: ProgressBar = health_bar_canvas.get_child(0)
	health_bar.value -= enemy_damaged


func _on_character_body_2d_input_map() -> void:
	view_map.set_visible(!view_map.is_visible())
