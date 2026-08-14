const RUTA = "user://puntuaciones.json"

var nombre_jugador = ""

func guardar_puntuacion(nombre: String, puntaje: int) -> void:
	var puntuaciones = cargar_puntuaciones()

	puntuaciones.append({
		"nombre": nombre,
		"puntaje": puntaje
	})

	var archivo = FileAccess.open(RUTA, FileAccess.WRITE)
	archivo.store_string(JSON.stringify(puntuaciones))
	archivo.close()


func cargar_puntuaciones() -> Array:
	if !FileAccess.file_exists(RUTA):
		return []

	var archivo = FileAccess.open(RUTA, FileAccess.READ)
	var texto = archivo.get_as_text()
	archivo.close()

	var datos = JSON.parse_string(texto)

	if datos is Array:
		return datos

	return []
