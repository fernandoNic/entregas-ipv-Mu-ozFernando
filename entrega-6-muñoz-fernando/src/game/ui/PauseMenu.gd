extends Control

## Menú de pausa genérico, abierto utilizando la acción "pause_menu"
## (por default la tecla Esc).
@export var level_manager_scene: PackedScene

signal return_selected()

func _ready() -> void:
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("pause_menu") && !$optionsMenu.visible:
		visible = !visible
		get_tree().paused = visible	

func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false	


func _on_return_button_pressed() -> void:
	hide_custom()
	#return_selected.emit()
	get_tree().change_scene_to_file("res://src/screens/MainMenu.tscn")

func hide_custom() -> void:
	hide()
	get_tree().paused = false
