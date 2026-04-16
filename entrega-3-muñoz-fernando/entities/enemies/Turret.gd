extends Sprite2D

@onready var fire_position: Node2D = $FirePosition
@onready var fire_timer: Timer     = $FireTimer
@export var projectile_scene: PackedScene
@onready var ray_cast:RayCast2D = $RayCast2D
@onready var player: Node2D = get_node("/root/Main/Player")
@onready var collision_shape = $DetectionArea/CollisionShape2D

var target_player: Node2D
var projectile_container: Node

func _ready() -> void:
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	
func _physics_process(delta):
	var radio_deteccion  = 280
	#print(str(collision_shape.shape.radius))
	var local_player_pos = to_local(player.global_position)

	if local_player_pos.length() > radio_deteccion:
		ray_cast.target_position = local_player_pos.limit_length(radio_deteccion)
	else:
		ray_cast.target_position = local_player_pos

func initialize(turret_pos: Vector2, projectile_container: Node) -> void:	
	global_position = turret_pos
	self.projectile_container = projectile_container

func fire_at_player() -> void:
	if ray_cast.is_colliding():
		var object_detected = ray_cast.get_collider()
		if object_detected == player:
			#fire_timer.start()	
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
	target_player = body
	fire_timer.start()	



func _on_detection_area_body_exited(body):
	if body == target_player:
		target_player = null
		fire_timer.stop()
