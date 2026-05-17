extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 1200.0

enum STATE {IDLE, RUN, JUMP, FALL}
var current_state : STATE

@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	_set_state(STATE.IDLE)

func _physics_process(delta: float) -> void:
	_update_state(delta)

func _set_state(new_state: STATE) -> void:
	if current_state == new_state:
		return
	
	_exit_state()
	current_state = new_state
	_enter_state()
	
func _enter_state() -> void:
	match current_state:
		STATE.IDLE: # Enter IDLE state logic
			animated_sprite_2d.play("idle")
			
		STATE.RUN: # Enter RUN state logic
			animated_sprite_2d.play("run")
			
		STATE.JUMP: # Enter JUMP state logic
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("jump")
			
		#STATE.FALL: # Enter FALL state logic
			#animated_sprite_2d.play("fall")	
			
func _update_state(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	match current_state:
		STATE.IDLE: # Update IDLE state logic
			if direction: # If left or right is pressed, start RUNing
				_set_state(STATE.RUN)
			elif !is_on_floor(): # if not on floor, fall down
				_set_state(STATE.FALL)
			elif Input.is_action_just_pressed("ui_accept"):
				_set_state(STATE.JUMP) # if the jump button is pressed, then jump
			
		STATE.RUN: # Update RUN state logic
			velocity.x = direction * SPEED # Set the move direction
			if velocity.x > 0: # Set Sprite direction
				animated_sprite_2d.flip_h = false
			elif velocity.x < 0:
				animated_sprite_2d.flip_h = true
				
			if !is_on_floor(): # if not on floor, fall down
				_set_state(STATE.FALL)
			elif Input.is_action_just_pressed("ui_accept"):
				_set_state(STATE.JUMP) # if jump is pressed, jump
			elif velocity.x == 0: # if standing still, then set idle
				_set_state(STATE.IDLE)
				
			move_and_slide()
			
		STATE.JUMP: # Update JUMP state logic
			velocity.x = direction * SPEED # Set the move direction
			if velocity.x > 0: # Set Sprite direction
				animated_sprite_2d.flip_h = false
			elif velocity.x < 0:
				animated_sprite_2d.flip_h = true
				
			if !is_on_floor(): # if in the air, apply gravity
				velocity.y += GRAVITY * delta
				if velocity.y > 0: # after max height, change from JUMP to FALL
					_set_state(STATE.FALL)
				
			move_and_slide()
			
		STATE.FALL: # Update FALL state logic
			velocity.x = direction * SPEED # Set the move direction
			if velocity.x > 0: # Set Sprite direction
				animated_sprite_2d.flip_h = false
			elif velocity.x < 0:
				animated_sprite_2d.flip_h = true
				
			if is_on_floor(): # If the ground is reached, change back to idle
				_set_state(STATE.IDLE)
			else: # if still in the air, apply gravity
				velocity.y += GRAVITY * delta
				
			move_and_slide()
			
func _exit_state() -> void:
	match current_state:
		STATE.IDLE: # Exit IDLE state logic
			pass
			
		STATE.RUN: # Exit RUN state logic
			pass
			
		STATE.JUMP: # Exit JUMP state logic
			pass
			
		STATE.FALL: # Exit FALL state logic
			pass
