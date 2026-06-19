extends Node

@onready var player : CharacterBody2D
var focus_in_map :bool
var focus_in_pause :bool

signal minimap_show

func get_main_player() -> CharacterBody2D:
	var world_container: Node2D = get_tree().current_scene.get_node_or_null("World")
	var player_container: Node2D = world_container.get_node_or_null("Player")
	GameManager.player = player_container.get_child(0) as CharacterBody2D
	return GameManager.player

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(_event):
	if Input.is_action_just_pressed("pause") && !focus_in_map:
		handle_pause()
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_pressed("ui_map") && !focus_in_pause:
		show_minimap()
		
func obtener_canvas():
	var escena_actual = get_tree().current_scene
	var canvas = escena_actual.get_node_or_null("UI").get_node_or_null("PauseLayer")
	return canvas
	
func handle_pause():
	var canvas_layer: CanvasLayer = obtener_canvas()
	canvas_layer.set_visible(!canvas_layer.is_visible())
	var overlay = canvas_layer.get_node("DarkOverlay")
	var tween = create_tween()
	
	if get_tree().is_paused():
		get_tree().set_pause(!get_tree().is_paused())
		tween.tween_property(overlay,"color:a",0,1.0)
	else:
		get_tree().set_pause(!get_tree().is_paused())
		tween.tween_property(overlay,"color:a",0.60,1.0)	
	focus_in_pause = canvas_layer.is_visible()
		
func show_minimap():
	if get_tree().is_paused():
		get_tree().set_pause(!get_tree().is_paused())
	else:
		get_tree().set_pause(!get_tree().is_paused())

	minimap_show.emit()
	
	var UI_node: Control = get_tree().current_scene.get_node_or_null("UI")
	var view_map: CanvasLayer = UI_node.get_node_or_null("view_map")
	view_map.set_visible(!view_map.is_visible())
	focus_in_map = view_map.is_visible()
