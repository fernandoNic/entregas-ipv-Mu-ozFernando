extends GenericStateMachine

@export var character: EnemyTurret
@export var dead_state: TurretState


func _setup() -> void:
	for state: TurretState in states_list:
		state.character = character


func notify_body_entered(body: Node) -> void:
	current_state.handle_event(&"body_entered", body)


func notify_body_exited(body: Node) -> void:
	current_state.handle_event(&"body_exited", body)


func notify_hit(_amount: int) -> void:
	if current_state != dead_state:
		_change_state(dead_state.state_id)


func _on_body_animation_finished() -> void:
	_on_animation_finished(character.get_current_animation())
