extends Control


func _on_boton_jugar_button_up() -> void:
	$menu_animacion.play("menu")

func _on_menu_animacion_animation_finished(anim_name):
	if anim_name == "menu":
		get_tree().change_scene_to_file("res://escenas/partida.tscn")

func _on_boton_salir_button_up() -> void:
	get_tree().quit()
