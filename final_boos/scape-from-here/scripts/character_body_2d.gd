extends CharacterBody2D

signal grab_keys
signal player_death
signal live_changed(enemy_damaged : int)

const SPEED = 200.0
const JUMP_VELOCITY = -260.0
const GRAVITY = 450.0

enum STATE {IDLE, RUN, JUMP, FALL, ATTACK, DEATH, DOUBLE_JUMP, HIT}
var current_state : STATE
var live: int = 100

#@onready var run_sfx: AudioStreamPlayer2D = $sfx/run_sfx
@onready var attack_sfx: AudioStreamPlayer2D = $sfx/attack_sfx
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_2d: CollisionShape2D = $hitbox/CollisionShape2D
@onready var hitbox: Area2D = $hitbox
@onready var double_jump_sfx: AudioStreamPlayer2D = $sfx/doubleJump_sfx
@onready var double_jump_vfx: AnimatedSprite2D = $DoubleJumpVfx
@onready var icon: Sprite2D = $icon
@onready var jump_sfx: AudioStreamPlayer2D = $sfx/jump_sfx
@onready var damage_sfx: AudioStreamPlayer2D = $sfx/damage_sfx


var max_jumps: int = 2
var jumps_left: int = 0

func _ready() -> void:
	GameManager.minimap_show.connect(show_on_minimap)
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
		STATE.JUMP:
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("jump_1")
			jump_sfx.play()
		STATE.DOUBLE_JUMP:
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("jump_1")
			double_jump_sfx.play()
			double_jump_vfx.visible = true
			double_jump_vfx.play("smoke_vfx")
			jump_sfx.play()
			if not double_jump_vfx.animation_finished.is_connected(_on_smoke_vfx_finished):
				double_jump_vfx.animation_finished.connect(_on_smoke_vfx_finished)
			jumps_left -= 1
		STATE.FALL:
			animated_sprite_2d.play("fall_1") 
		STATE.ATTACK:
			animated_sprite_2d.play("attack_2")
			attack_sfx.play()
			hitbox_2d.disabled = !hitbox_2d.disabled
			if not animated_sprite_2d.animation_finished.is_connected(_on_attack_animation_finished):
				animated_sprite_2d.animation_finished.connect(_on_attack_animation_finished)
		STATE.HIT:
			animated_sprite_2d.play("hit") 
			damage_sfx.play()
			if not animated_sprite_2d.animation_finished.is_connected(_on_hit_animation_finished):
				animated_sprite_2d.animation_finished.connect(_on_hit_animation_finished)
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
		STATE.HIT:
			if animated_sprite_2d.animation_finished.is_connected(_on_hit_animation_finished):
				animated_sprite_2d.animation_finished.disconnect(_on_hit_animation_finished)
		STATE.RUN:
			pass
			
func _update_state(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right") # 1 right -1 left
	if direction != 0 and current_state != STATE.ATTACK:
		animated_sprite_2d.flip_h = (direction < 0)
		hitbox.scale.x = direction
	
	match current_state:
		STATE.IDLE:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				jumps_left = max_jumps - 1 
			
			if not is_on_floor():
				_set_state(STATE.FALL)
				jumps_left = max_jumps - 1 
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
				jumps_left = max_jumps - 1 
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
			if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
				_set_state(STATE.DOUBLE_JUMP)
			elif velocity.y > 0:
				_set_state(STATE.FALL)
			move_and_slide()
		
		STATE.DOUBLE_JUMP:
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
			elif Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
				_set_state(STATE.DOUBLE_JUMP)
			move_and_slide()
			
		STATE.ATTACK:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED)
			_aplicar_gravedad(delta)
			move_and_slide()
		STATE.HIT:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
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


func receive_damage(enemy_damage: int,enemy_pos: Vector2) -> void:
	if current_state == STATE.DEATH or current_state == STATE.HIT:
		return
		
	live -= enemy_damage	
	live_changed.emit(enemy_damage)
	
	if live <= 0:
		_set_state(STATE.DEATH)
	else:
		var knockback_dir = 1.0 if global_position.x > enemy_pos.x else -1.0
		velocity.x = knockback_dir * 300.0
		velocity.y = -120.0  
		_set_state(STATE.HIT)

func _on_smoke_vfx_finished() -> void:
	double_jump_vfx.visible = false
	if double_jump_vfx.animation_finished.is_connected(_on_smoke_vfx_finished):
		double_jump_vfx.animation_finished.disconnect(_on_smoke_vfx_finished)


func show_on_minimap() -> void:
	pass
	#icon.visible = !icon.visible

func _on_hit_animation_finished() -> void:
	if current_state == STATE.HIT:
		_set_state(STATE.IDLE)
