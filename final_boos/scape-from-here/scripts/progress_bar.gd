extends ProgressBar

var fuerza_temblor : float = 0.0
var decaimiento : float = 25.0

func _process(delta: float) -> void:
	if fuerza_temblor > 0:
		fuerza_temblor = move_toward(fuerza_temblor, 0.0, decaimiento * delta)

		rotation = randf_range(-fuerza_temblor, fuerza_temblor) * 0.01
		scale = Vector2(
			1.0 + randf_range(-fuerza_temblor, fuerza_temblor) * 0.02,
			1.0 + randf_range(-fuerza_temblor, fuerza_temblor) * 0.02
		)
	else:
		rotation = 0.0
		scale = Vector2.ONE
	
func recibir_daño() -> void:
	fuerza_temblor = 10.0 	
