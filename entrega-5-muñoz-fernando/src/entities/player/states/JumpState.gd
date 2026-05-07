extends PlayerState

#class_name JumpState

@export var jumps_limit:int = 1
var jumps:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Al entrar se activa primero la animación "idle"
func enter() -> void:
	character.velocity.y -= character.jump_speed
	character._play_animation("jump")
	
func exit() -> void:
	jumps = 0	

func handle_input(event: InputEvent) -> void:
	# Aquí se podría manejar, por ejemplo, transiciones a estados como Jump
	if event.is_action_pressed("jump") && jumps < jumps_limit:
		jumps += 1
		character.velocity.y -= character.jump_speed
		character._play_animation("jump")
		

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
	
func _on_animation_finished(anim_name: StringName) -> void:
	return	
	
# En este callback manejamos, por el momento, solo los impactos
func handle_event(event: StringName, value = null) -> void:
	match event:
		&"hit":
			character._handle_hit(value)
			if character.dead:
				finished.emit(&"dead")	
