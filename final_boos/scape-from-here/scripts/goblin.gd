extends Node2D

@export var max_health: float = 100.0
@onready var progress_bar: ProgressBar = $CharacterBody2D/ProgressBar
@onready var animated_sprite_2d: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

var current_health: float

func _ready() -> void:
	current_health = max_health
	progress_bar.max_value = max_health
	progress_bar.value = current_health

func be_harmed(amount:float) -> void:
	current_health -= amount
	current_health = clamp(current_health,0.0,max_health)
	progress_bar.value = current_health
	
	if current_health == 0:
		death()

func death():
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	queue_free()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		be_harmed(10.0)
