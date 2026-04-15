extends CanvasLayer

func _ready() -> void:
	visible = false
	
func _on_cancelar_button_up() -> void:
	visible = false
	get_tree().paused = false


func _on_salir_button_up() -> void:
	get_tree().quit()
