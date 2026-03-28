extends Sprite2D

@export var speed:float = 200

func _process(delta):
	#var direction:int = 0
	 
	#if Input.is_action_pressed("mover_izq"):
		#print(int(Input.is_action_pressed("mover_izq")))
		#direction = -1
	#elif Input.is_action_pressed("mover_der"):
		#print(int(Input.is_action_pressed("mover_der")))
		#direction = 1
		
	var direction:int = int(Input.is_action_pressed("mover_der")) - int(Input.is_action_pressed("mover_izq"))
	position.x += direction * speed * delta

	
