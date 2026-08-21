extends Control

@onready var lista = $PanelContainer/VBoxContainer/lista_puntuaciones
func _ready() -> void:
	mostrar_puntuaciones()

func mostrar_puntuaciones() -> void:
	var puntuaciones = Puntuaciones.obtener_mejores_puntuaciones()

	var cantidad = min(puntuaciones.size(), 10)

	for i in range(cantidad):
		var puntuacion = puntuaciones[i]

		var fila = HBoxContainer.new()

		var nombre = Label.new()
		nombre.text = str(i + 1) + ". " + puntuacion["nombre"]
		nombre.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var puntaje = Label.new()
		puntaje.text = str(puntuacion["puntaje"])
		puntaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		fila.add_child(nombre)
		fila.add_child(puntaje)

		lista.add_child(fila)
