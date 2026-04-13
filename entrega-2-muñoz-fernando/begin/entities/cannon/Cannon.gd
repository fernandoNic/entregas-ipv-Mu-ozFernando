extends Node2D

@export var escena_proyectil: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()

func shoot():
	var projectile = escena_proyectil.instantiate()
	projectile.direction = global_transform.x
	projectile.global_position  = global_position 
	get_tree().current_scene.add_child(projectile)
