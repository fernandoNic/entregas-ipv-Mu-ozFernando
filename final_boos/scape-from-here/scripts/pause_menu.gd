extends Control
@onready var audio_stream_player_2d: AudioStreamPlayer = $sfx/button_action

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_quit_to_menu_pressed() -> void:
	GameManager.handle_pause()
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_resume_game_pressed() -> void:
	GameManager.handle_pause()

func _on_resume_game_mouse_entered() -> void:
	audio_stream_player_2d.play()

func _on_quit_to_menu_mouse_entered() -> void:
	audio_stream_player_2d.play()

func _on_restart_level_pressed() -> void:
	GameManager.handle_pause()
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
