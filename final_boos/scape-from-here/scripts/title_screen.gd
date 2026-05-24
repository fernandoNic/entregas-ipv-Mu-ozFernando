extends Control

@onready var navigation_sound: AudioStreamPlayer = $sfx/navigation_sound
@onready var start_game: Button = $"VBoxContainer/start game"
@onready var credits: Button = $VBoxContainer/credits
@onready var quit_game: Button = $"VBoxContainer/quit game"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	start_game.grab_focus()

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")	

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_game_mouse_entered() -> void:
	start_game.grab_focus()
	navigation_sound.play()

func _on_credits_mouse_entered() -> void:
	credits.grab_focus()
	navigation_sound.play()

func _on_quit_game_mouse_entered() -> void:
	quit_game.grab_focus()
	navigation_sound.play()

func _on_start_game_focus_entered() -> void:
	start_game.grab_focus()
	navigation_sound.play()

func _on_credits_focus_entered() -> void:
	credits.grab_focus()
	navigation_sound.play()

func _on_quit_game_focus_entered() -> void:
	quit_game.grab_focus()
	navigation_sound.play()
