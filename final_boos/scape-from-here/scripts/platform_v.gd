extends AnimatableBody2D

# Distancia vertical que se moverá (en píxeles)
@export var _distancia: float = 300.0
# Tiempo que tarda en subir o bajar (en segundos)
@export var _duracion: float = 2.0
@export var first_direction: int = 1

#var _posicion_inicial : Vector2
#var _posicion_final : float

func _ready() -> void:
	_iniciar_movimiento()
	
func _iniciar_movimiento() -> void:
	set_direcction()
	
func set_direcction() -> void:
	var _posicion_inicial = global_position
	var _posicion_final   = _posicion_inicial + Vector2(0, -_distancia) 
	
	var _tween = create_tween().set_loops()
	
	if first_direction == 1:
		# Transición hacia arriba (restar en Y sube la plataforma)
		var _paso1 = _tween.tween_property(self, "global_position", _posicion_final, _duracion)
		# Transición de regreso hacia abajo
		var _paso2 = _tween.tween_property(self, "global_position", _posicion_inicial, _duracion)
	if first_direction != 1:
		## Transición de regreso hacia abajo
		var _paso1 = _tween.tween_property(self, "global_position", _posicion_inicial, _duracion)
		# Transición hacia arriba (restar en Y sube la plataforma)
		var _paso2 = _tween.tween_property(self, "global_position", _posicion_final, _duracion)
