extends CanvasLayer

# Ruta de la escena del juego que queremos cargar
var ruta_escena: String = "res://scenes/level.tscn" 
var progreso: Array = []

func _ready():
	ResourceLoader.load_threaded_request(ruta_escena)

func _process(_delta):
	var estado = ResourceLoader.load_threaded_get_status(ruta_escena, progreso)
	
	match estado:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			$ProgressBar.value = progreso[0] * 100
				
		ResourceLoader.THREAD_LOAD_LOADED:
			var nueva_escena = ResourceLoader.load_threaded_get(ruta_escena)
			get_tree().change_scene_to_packed(nueva_escena)
			
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error: No se pudo cargar la escena.")
			set_process(false)
			
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("Error: Ruta de recurso inválida.")
			set_process(false)
