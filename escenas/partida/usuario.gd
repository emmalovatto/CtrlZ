extends Control

func _on_button_button_up() -> void:
	var nombre = $ColorRect/VBoxContainer/LineEdit.text.strip_edges()
	
	if nombre == "":
		return 
	
	Puntuaciones.nombre_jugador = nombre
	get_tree().change_scene_to_file("res://escenas/partida/partida.tscn")
