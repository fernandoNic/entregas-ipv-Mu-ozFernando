extends Node2D

@onready var weapon_tip: Node2D = $WeaponTip

@export var projectile_scene: PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var weapon: Node2D = %Weapon

var projectile_container: Node


## Desacoplamos el manejo del arma para que maneje su propia lógica.
## Es útil si queremos controlar su implementación independientemente
## o si queremos introducir variedad (muchas armas, por ejemplo).
func process_input() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	weapon.look_at(mouse_position)


func fire() -> void:
	var projectile_instance: Node = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.initialize(
		weapon_tip.global_position,
		global_position.direction_to(weapon_tip.global_position)
	)
