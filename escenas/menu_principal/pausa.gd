extends CanvasLayer

@onready var sonido_boton = $AudioStreamPlayer


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
	get_tree().change_scene_to_file("res://escenas/menu_principal/menu.tscn")


func _on_salir_button_up() -> void:
	visible = false
	$ConfirmarSalida.visible = true


func _on_boton_reanudar_mouse_entered() -> void:
	sonido_boton.play()


func _on_boton_ajustes_mouse_entered() -> void:
	sonido_boton.play()


func _on_boton_menu_mouse_entered() -> void:
	sonido_boton.play()


func _on_boton_salir_mouse_entered() -> void:
	sonido_boton.play()
