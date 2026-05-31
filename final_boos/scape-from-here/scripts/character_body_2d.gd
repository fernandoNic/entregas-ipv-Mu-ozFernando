extends CharacterBody2D

signal grab_keys
signal player_death
signal live_changed(enemy_damaged : int)

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 450.0

enum STATE {IDLE, RUN, JUMP, FALL, ATTACK, DEATH}
var current_state : STATE
var live: int = 100

@onready var run_sfx: AudioStreamPlayer2D = $sfx/run_sfx
@onready var attack_sfx: AudioStreamPlayer2D = $sfx/attack_sfx
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_2d: CollisionShape2D = $hitbox/CollisionShape2D
@onready var hitbox: Area2D = $hitbox

func _ready() -> void:
	current_state = STATE.IDLE
	_enter_state()

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
		STATE.IDLE:
			animated_sprite_2d.play("idle_1")
		STATE.RUN:
			animated_sprite_2d.play("run_1")
			if not run_sfx.playing:
				run_sfx.play()	
		STATE.JUMP:
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("jump_1")
		STATE.FALL:
			animated_sprite_2d.play("fall_1") 
		STATE.ATTACK:
			animated_sprite_2d.play("attack_2")
			attack_sfx.play()
			hitbox_2d.disabled = !hitbox_2d.disabled
			if not animated_sprite_2d.animation_finished.is_connected(_on_attack_animation_finished):
				animated_sprite_2d.animation_finished.connect(_on_attack_animation_finished)
		STATE.DEATH:
			player_death.emit()
			animated_sprite_2d.play("death")
			await animated_sprite_2d.animation_finished
			queue_free()
			
func _exit_state() -> void:
	match current_state:
		STATE.ATTACK:
			if animated_sprite_2d.animation_finished.is_connected(_on_attack_animation_finished):
				animated_sprite_2d.animation_finished.disconnect(_on_attack_animation_finished)
				hitbox_2d.disabled = !hitbox_2d.disabled
		STATE.RUN:
			run_sfx.stop()

func _update_state(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right") # 1 right -1 left
	if direction != 0 and current_state != STATE.ATTACK:
		animated_sprite_2d.flip_h = (direction < 0)
		hitbox.scale.x = direction

	match current_state:
		STATE.IDLE:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if not is_on_floor():
				_set_state(STATE.FALL)
			elif direction != 0:
				_set_state(STATE.RUN)
			elif Input.is_action_just_pressed("ui_accept"):
				_set_state(STATE.JUMP)
			elif Input.is_action_just_pressed("attack"):
				_set_state(STATE.ATTACK)
			
			_aplicar_gravedad(delta)
			move_and_slide()

		STATE.RUN:
			velocity.x = direction * SPEED
			if not is_on_floor():
				_set_state(STATE.FALL)
			elif Input.is_action_just_pressed("ui_accept"):
				_set_state(STATE.JUMP)
			elif Input.is_action_just_pressed("attack"):
				_set_state(STATE.ATTACK)
			elif direction == 0:
				_set_state(STATE.IDLE)
				
			_aplicar_gravedad(delta)
			move_and_slide()
			
		STATE.JUMP:
			velocity.x = direction * SPEED
			_aplicar_gravedad(delta)
			if velocity.y > 0:
				_set_state(STATE.FALL)
			move_and_slide()
			
		STATE.FALL:
			velocity.x = direction * SPEED
			_aplicar_gravedad(delta)
			if is_on_floor():
				_set_state(STATE.IDLE)
			move_and_slide()
			
		STATE.ATTACK:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED)
			_aplicar_gravedad(delta)
			move_and_slide()

func _aplicar_gravedad(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func _on_attack_animation_finished() -> void:
	if current_state == STATE.ATTACK:
		_set_state(STATE.IDLE)

func grab_a_key() -> void:
	grab_keys.emit()
		
func receive_damage(enemy_damage: int) -> void:
	live -= enemy_damage	
	live_changed.emit(enemy_damage)
	if live <= 0:
		_set_state(STATE.DEATH)
	
