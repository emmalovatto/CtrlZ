extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("volver_menu"):
		get_tree().paused = false
		get_tree().reload_current_scene()
