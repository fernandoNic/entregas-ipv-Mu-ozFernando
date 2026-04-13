extends Node2D

@export var escena_proyectil: PackedScene
@onready var objetivo:  = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	disparar_loop()

func disparar_loop():
	while true:
		disparar()
		await get_tree().create_timer(1.5).timeout

func disparar():
	if objetivo == null:
		return

	var proyectil = escena_proyectil.instantiate()
	proyectil.global_position = global_position
	var direccion = (objetivo.global_position - global_position).normalized()
	proyectil.direccion = direccion
	
	get_tree().current_scene.add_child(proyectil)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
