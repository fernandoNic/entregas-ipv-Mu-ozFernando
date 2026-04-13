extends Node2D

#@onready var objetivo: Node2D = get_node("../Player")

var direccion: Vector2
@export var velocidad := 2
var torreta: Node2D

func _process(delta):
	position += direccion * velocidad * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
