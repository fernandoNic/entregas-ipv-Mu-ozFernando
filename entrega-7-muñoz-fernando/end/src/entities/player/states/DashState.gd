extends PlayerState

@export var dash_time: float = 1.0
@export var speed_multiplier: float = 1.0
@export var dash_cooldown: float = 1.0
@export var dash_cooldown_color: Color

var dash_timer: Timer


func _ready() -> void:
	dash_timer = Timer.new()
	add_child(dash_timer)
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_on_dash_timer_timeout)


func enter() -> void:
	dash_timer.start(dash_time)
	character.dash_cooldown.start(dash_cooldown)
	character._play_animation(&"dash")
	character.body.self_modulate = dash_cooldown_color
	create_tween().tween_property(
		character.body,
		"self_modulate",
		Color.WHITE,
		dash_cooldown
	)


func exit() -> void:
	dash_timer.stop()


func update(delta: float) -> void:
	character._handle_weapon_actions()
	character.velocity.x = clamp(
		character.velocity.x + (character.h_movement_direction * character.acceleration * speed_multiplier * delta),
		-character.h_speed_limit * speed_multiplier,
		character.h_speed_limit * speed_multiplier
	)
	character._apply_movement(delta)


func _on_dash_timer_timeout() -> void:
	character._handle_move_input(get_physics_process_delta_time())
	if character.h_movement_direction == 0:
		finished.emit(&"idle")
	else:
		finished.emit(&"walk")


func handle_event(event: StringName, value = null) -> void:
	match event:
		&"hit":
			character._handle_hit(value)
			if character.dead:
				finished.emit(&"dead")


func handle_input(_event: InputEvent) -> void:
	return


func _on_animation_finished(_anim_name: StringName) -> void:
	return
