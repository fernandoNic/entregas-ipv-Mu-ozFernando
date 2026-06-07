extends CharacterBody2D
class_name EnemyTurret

signal hit(amount: int)

@onready var fire_position: Node2D = $FirePosition
@onready var raycast: RayCast2D = $RayCast2D
@onready var body_anim: AnimatedSprite2D = $Body

@onready var enemy_sfx: AudioStreamPlayer = $EnemySFX
@export var fire_sfx: AudioStream


@export var projectile_scene: PackedScene
@export var pathfinding: PathfindAstar

var target: Node2D
var _projectile_container: Node

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false


func initialize(turret_pos: Vector2, projectile_container: Node) -> void:
	global_position = turret_pos
	self._projectile_container = projectile_container


func _fire() -> void:
	if target != null:
		_fire_audio()
		var proj_instance: Node = projectile_scene.instantiate()
		if _projectile_container == null:
			_projectile_container = get_parent()
		_projectile_container.add_child(proj_instance)
		proj_instance.initialize(
			fire_position.global_position,
			fire_position.global_position.direction_to(target.global_position)
		)


# Al igual que con el script del player, abstraemos a una función la detección del target
func _can_see_target() -> bool:
	if target == null:
		return false
	raycast.target_position = raycast.to_local(target.global_position)
	raycast.force_raycast_update()
	return raycast.is_colliding() && raycast.get_collider() == target


# Damos vuelta el cuerpo para que mire al objetivo en el eje x
# y usamos la dirección a la que se casteó el raycast
# Otra manera sería hacer (target.global_position - global_position).x < 0
# La ventaja de esta manera es que no dependemos de que exista un target
func _look_at_target() -> void:
	body_anim.flip_h = raycast.target_position.x < 0


# Esta función ya no llama directamente a remove, sino que inhabilita las
# colisiones con el mundo, pausa todo lo demás y ejecuta una animación de muerte
# dependiendo de si el enemigo esta o no alerta
func notify_hit(amount: int = 1) -> void:
	hit.emit(amount)


func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


# Wrapper sobre el llamado a animación para tener un solo punto de entrada controlable
# (en el caso de que necesitemos expandir la lógica o debuggear, por ejemplo)
func _play_animation(animation: String) -> void:
	if body_anim.sprite_frames.has_animation(animation):
		body_anim.play(animation)


# Wrapper para facilitar el acceso a la animación actual
func get_current_animation() -> String:
	return body_anim.animation

func _fire_audio() -> void:
	enemy_sfx.stream = load("res://assets/sound/sfx/enemies/20_orc_special_atk.wav")
	enemy_sfx.play()	
