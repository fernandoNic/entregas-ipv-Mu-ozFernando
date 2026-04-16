extends Sprite2D

@onready var fire_position: Node2D = $FirePosition
@onready var fire_timer: Timer     = $FireTimer
@export var projectile_scene: PackedScene

var target_player: Node2D = null # Guardamos la referencia del jugador
var projectile_container: Node

func _ready() -> void:
	# Conectamos la señal del Timer por código o desde el editor
	fire_timer.timeout.connect(_on_fire_timer_timeout)

#func initialize(turret_pos: Vector2, player: Node2D, projectile_container: Node) -> void:
func initialize(turret_pos: Vector2, projectile_container: Node) -> void:	
	global_position = turret_pos
	self.projectile_container = projectile_container

func fire_at_player() -> void:
	if target_player:
		var proj_instance = projectile_scene.instantiate()
		proj_instance.initialize(
			projectile_container,
			fire_position.global_position,
			fire_position.global_position.direction_to(target_player.global_position)
		)

func _on_fire_timer_timeout() -> void:
	fire_at_player()
	
func _on_detection_area_body_entered(body):
	#print(body)
	target_player = body
	fire_at_player()
	fire_timer.start()


func _on_detection_area_body_exited(body):
	if body == target_player:
		target_player = null
		fire_timer.stop()
