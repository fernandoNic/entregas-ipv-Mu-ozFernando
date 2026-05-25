extends Control
@onready var btn_music: AudioStreamPlayer = $sfx/btn_music
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
@export var duracion_animacion: float = 50.0
@onready var back_menu: Button = $"CanvasLayer/back menu"
@onready var space_begin: Control = $ScrollContainer/VBoxContainer/space_begin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_menu.grab_focus()
	var screen_heigh = get_viewport().get_visible_rect().size.y
	var screen_width = get_viewport().get_visible_rect().size.x
	space_begin.custom_minimum_size.y = screen_heigh
	space_begin.custom_minimum_size.x = screen_width
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	start_credits()

func start_credits():
	await get_tree().process_frame
	var scroll_maximo = v_box_container.size.y
	scroll_container.scroll_vertical = 0
	
	var tween = create_tween()
	tween.tween_property(scroll_container, "scroll_vertical", scroll_maximo, duracion_animacion)

func _on_back_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_back_menu_mouse_entered() -> void:
	btn_music.play()
