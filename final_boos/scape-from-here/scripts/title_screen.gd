extends Control

@onready var navigation_sound: AudioStreamPlayer2D = $sfx/navigation_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")	

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_game_mouse_entered() -> void:
	navigation_sound.play()

func _on_credits_mouse_entered() -> void:
	navigation_sound.play()

func _on_quit_game_mouse_entered() -> void:
	navigation_sound.play()
