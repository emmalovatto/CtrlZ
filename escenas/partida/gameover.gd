extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("volver_menu"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://escenas/menu_principal/menu.tscn")
