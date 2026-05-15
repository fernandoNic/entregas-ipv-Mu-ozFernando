extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		handle_pause()
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
func obtener_canvas():
	# Accedemos a la escena que el usuario está viendo actualmente
	var escena_actual = get_tree().current_scene #level
	# Buscamos el nodo por nombre (debe estar en la raíz de esa escena)
	var canvas = escena_actual.get_node_or_null("UI").get_node_or_null("PauseLayer")
	#var canvas = escena_actual.get_node_or_null("CharacterBody2D")
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
