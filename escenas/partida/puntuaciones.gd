extends Node

const RUTA = "user://puntuaciones.json"

# Se mantiene durante toda la sesión del juego
var nombre_jugador = ""


func guardar_puntuacion(nombre: String, puntaje: int) -> void:
	nombre = nombre.strip_edges()

	if nombre.is_empty():
		return

	var puntuaciones = cargar_puntuaciones()
	var puntuaciones_limpias = []
	var indice_jugador = -1
	
	for registro in puntuaciones:
		var nombre_guardado = str(
			registro.get("nombre", "")
		).strip_edges()

		if nombre_guardado.is_empty():
			continue

		var indice_existente = -1

		for i in range(puntuaciones_limpias.size()):
			if str(
				puntuaciones_limpias[i]["nombre"]
			).to_lower() == nombre_guardado.to_lower():
				indice_existente = i
				break

		if indice_existente == -1:
			puntuaciones_limpias.append({
				"nombre": nombre_guardado,
				"puntaje": int(registro.get("puntaje", 0))
			})
		else:
			puntuaciones_limpias[indice_existente]["puntaje"] = max(
				int(puntuaciones_limpias[indice_existente]["puntaje"]),
				int(registro.get("puntaje", 0))
			)

	for i in range(puntuaciones_limpias.size()):
		if str(
			puntuaciones_limpias[i]["nombre"]
		).to_lower() == nombre.to_lower():
			indice_jugador = i
			break

	if indice_jugador == -1:
		puntuaciones_limpias.append({
			"nombre": nombre,
			"puntaje": puntaje
		})
	else:
		puntuaciones_limpias[indice_jugador]["puntaje"] = max(
			int(puntuaciones_limpias[indice_jugador]["puntaje"]),
			puntaje
		)

	guardar_archivo(puntuaciones_limpias)

func guardar_archivo(puntuaciones: Array) -> void:
	var archivo = FileAccess.open(RUTA, FileAccess.WRITE)

	if archivo:
		archivo.store_string(JSON.stringify(puntuaciones))
		archivo.close()

func cargar_puntuaciones() -> Array:
	if not FileAccess.file_exists(RUTA):
		return []

	var archivo = FileAccess.open(RUTA, FileAccess.READ)

	if archivo == null:
		return []

	var texto = archivo.get_as_text()
	archivo.close()

	var datos = JSON.parse_string(texto)

	if datos is Array:
		return datos

	return []

func obtener_mejores_puntuaciones() -> Array:
	var puntuaciones = cargar_puntuaciones()

	puntuaciones.sort_custom(func(a, b):
		return int(a["puntaje"]) > int(b["puntaje"])
	)
	return puntuaciones

	
	
