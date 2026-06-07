extends CharacterBody2D

# bigeye script
# Componentes obligatorios en la escena
@export var max_health: float = 100.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_L: RayCast2D = $RayCast2D
@onready var ray_cast_R: RayCast2D = $RayCast2D2
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var damage: float = 40
@onready var line_of_view: RayCast2D = $line_of_view
@onready var vision_range: Area2D = $vision_range
@onready var hitbox: Area2D = $hitbox
@onready var hitbox_shape: CollisionShape2D = $hitbox/CollisionShape2D
@onready var ray_wall: RayCast2D = $RayWall

# Parámetros configurables
@export var speed: float = 100.0
@export var gravity: float = 980.0
@export var ATTACK_RANGE: float = 30.0
@export var attack: int = 5

# Estados de la FSM
enum State { IDLE, RUN, ATTACK, HIT, DEATH, CHASE }
var current_state: State = State.RUN
var current_health: float
# Variables de control de movimiento
var direction: float = 1.0 # 1 right -1 left
var is_waiting: bool = false
var wait_timer: float = 0.0
var player: CharacterBody2D


func _ready() -> void:
	current_health = max_health
	progress_bar.max_value = max_health
	progress_bar.value = current_health
	
func _physics_process(delta: float) -> void:
	#if ray_wall.is_colliding():
		#pass
	
	# Manejo de la máquina de estados
	if not is_on_floor():
		velocity.y += gravity * delta
		
	match current_state:
		State.IDLE:
			handle_idle_state(delta)
		State.RUN:
			handle_run_state()
		State.ATTACK:
			handle_attack_state()
		State.HIT:
			handle_hit_state()
		State.CHASE:
			handle_chase_state()
		State.DEATH:
			handle_death_state()

	move_and_slide()
	

func handle_idle_state(delta: float) -> void:
	velocity.x = 0
	sprite.play("idle")
	
	if can_pursue() and line_of_view.is_colliding():
		is_waiting = false
		change_state(State.CHASE)
		return
		
	if is_waiting:
		wait_timer -= delta
		if wait_timer <= 0:
			is_waiting = false
			change_state(State.RUN)

func handle_attack_state() -> void:
	velocity.x = 0
	if current_state == State.ATTACK and sprite.animation != "attack":
		sprite.play("attack")
		if not sprite.frame_changed.is_connected(_on_attack_frame_changed):
			sprite.frame_changed.connect(_on_attack_frame_changed)
		
		await sprite.animation_finished
		
		if sprite.frame_changed.is_connected(_on_attack_frame_changed):
			sprite.frame_changed.disconnect(_on_attack_frame_changed)
		
		change_state(State.CHASE)

func handle_hit_state() -> void:
	velocity.x = 0
	if current_state == State.HIT:
		sprite.play("hit")
		await sprite.animation_finished

		var real_direction_to_player = sign(player.global_position.x - global_position.x)

		if direction != real_direction_to_player and real_direction_to_player != 0:
			direction = real_direction_to_player # Corregimos la variable de dirección
			update_sprite_direction()   

		if line_of_view.is_colliding() and line_of_view.get_collider() == player:
			change_state(State.ATTACK)
		else:
			change_state(State.CHASE)

func handle_death_state() -> void:
	velocity.x = 0
	sprite.play("death")
	await sprite.animation_finished
	queue_free()		
	set_physics_process(false)

func handle_chase_state() -> void:
	if not player:
		change_state(State.IDLE)
		return
	
	if line_of_view.is_colliding() and can_pursue():
		var direction_to_player = player.global_position.x - global_position.x
		var distance_to_player = abs(direction_to_player)
		sprite.play("idle")
		speed = 200
	
		if distance_to_player <= ATTACK_RANGE:
			velocity.x = 0
			change_state(State.ATTACK)
		else:
			velocity.x = sign(direction_to_player) * speed
	else:
		velocity.x = 0
		change_state(State.IDLE) 

func handle_run_state() -> void:
	velocity.x = direction * speed
	sprite.play("idle")
	update_sprite_direction()
	check_platform_edges()

	if is_on_wall():
		velocity = Vector2.ZERO
		wait_timer = 3.0         
		is_waiting = true
		change_state(State.IDLE)
		
func check_platform_edges() -> void:
	if !raycast_L.is_colliding() and direction == -1:
		direction *= -1          
		wait_timer = 3.0         
		is_waiting = true
		change_state(State.IDLE)
	if !ray_cast_R.is_colliding() and direction == 1:
		direction *= -1          
		wait_timer = 3.0         
		is_waiting = true
		change_state(State.IDLE)
	if ray_wall.is_colliding():
		velocity = Vector2.ZERO
		wait_timer = 3.0         
		is_waiting = true
		direction *= -1          
		change_state(State.IDLE)
	if raycast_L.is_colliding() && ray_cast_R.is_colliding() && ray_wall.is_colliding():
		velocity.x = direction * speed
		change_state(State.IDLE)
		
# 1 right -1 left			
func update_sprite_direction() -> void:
	if direction > 0:
		sprite.flip_h = false
		vision_range.scale.x = direction
		line_of_view.scale.x = direction
		hitbox.scale.x       = direction
		ray_wall.scale.x     = direction
	elif direction < 0:
		sprite.flip_h = true
		vision_range.scale.x = direction
		line_of_view.scale.x = direction
		hitbox.scale.x       = direction
		ray_wall.scale.x     = direction

func change_state(new_state: State) -> void:
	if current_state == State.DEATH: 
		return
	if current_state == new_state: 
		return		
	current_state = new_state


func take_damage() -> void:
	if current_state == State.DEATH or current_state == State.HIT:
		return 
	
	change_state(State.HIT)
	be_harmed(damage)


func death():
	sprite.play("death")
	await sprite.animation_finished
	queue_free()		

	
func be_harmed(amount:float) -> void:
	current_health -= amount
	current_health = clamp(current_health,0.0,max_health)
	progress_bar.value = current_health
	
	if current_health <= 0:
		change_state(State.DEATH)
	else:
		await sprite.animation_finished
		if current_state == State.HIT:
			change_state(State.ATTACK)


func handle_combat_state() -> void:
	change_state(State.CHASE)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == 'hitbox':
		player = GameManager.get_main_player()
		take_damage()

		
func _on_vision_range_body_entered(body: Node2D) -> void:
	player = body
	change_state(State.CHASE)


func _on_vision_range_body_exited(_body: Node2D) -> void:
	speed = 100.0
	is_waiting = true
	wait_timer = 3.0  
	change_state(State.IDLE)

	
func can_pursue() -> bool:
	return (raycast_L.is_colliding() and direction == -1) or (ray_cast_R.is_colliding() and direction == 1)


func _on_attack_frame_changed() -> void:
	if sprite.animation == "attack":
		# Frame 0 al 5: El enemigo está preparando el golpe (Anticipación)
		if sprite.frame <= 5:
			hitbox_shape.disabled = true
			
		# Frame 6: El golpe inicia e impacta al jugador (Activación)
		elif sprite.frame == 6:
			hitbox_shape.disabled = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	area.take_damage(attack)
