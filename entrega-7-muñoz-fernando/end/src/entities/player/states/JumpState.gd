extends PlayerState

@export var jumps_limit: int = 1
@onready var player_sfx: AudioStreamPlayer = $"../../PlayerSFX"


var jumps: int = 0


func enter() -> void:
	character.velocity.y = -character.jump_speed
	_jump_audio()
	character._play_animation(&"jump")


func exit() -> void:
	jumps = 0


func handle_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed(&"dash") &&
		character.h_movement_direction != 0 &&
		character.dash_cooldown.is_stopped()
	):
		finished.emit(&"dash")
	elif event.is_action_pressed(&"jump") && jumps < jumps_limit:
		jumps += 1
		character.velocity.y = -character.jump_speed
		character._play_animation(&"jump")
		


func update(delta: float) -> void:
	character._handle_weapon_actions()
	character._handle_move_input(delta)
	if character.h_movement_direction == 0:
		character._handle_deacceleration(delta)
	character._apply_movement(delta)
	if character.is_on_floor():
		if character.h_movement_direction == 0:
			finished.emit(&"idle")
		else:
			finished.emit(&"walk")
	else:
		if character.velocity.y > 0:
			character._play_animation(&"fall")
		else:
			character._play_animation(&"jump")


func handle_event(event: StringName, value = null) -> void:
	match event:
		&"hit":
			character._handle_hit(value)
			if character.dead:
				finished.emit(&"dead")


func _on_animation_finished(_anim_name: StringName) -> void:
	return

func _jump_audio() -> void:
	player_sfx.stream = load("res://assets/sound/sfx/jump/12_human_jump_3.wav")
	player_sfx.play()
