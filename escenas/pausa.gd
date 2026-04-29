extends CanvasLayer


func _ready() -> void:
	visible = false


func _on_reanudar_button_up() -> void:
	visible = false
	get_tree().paused = false


func _on_ajustes_button_up() -> void:
	visible = false
	get_tree().paused = false
	$ajustes.visible = true


func _on_menu_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/menu.tscn")


func _on_salir_button_up() -> void:
	visible = false
	$ConfirmarSalida.visible = true
