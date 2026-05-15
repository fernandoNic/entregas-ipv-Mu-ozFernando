extends Control
@onready var btn_music: AudioStreamPlayer2D = $sfx/btn_music


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_back_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_back_menu_mouse_entered() -> void:
	btn_music.play()
