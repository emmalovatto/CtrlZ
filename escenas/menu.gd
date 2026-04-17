extends Control

@onready var boton_jugar = $CanvasLayer/VBoxContainer/boton_jugar
@onready var boton_instrucciones = $CanvasLayer/VBoxContainer/boton_instrucciones
@onready var boton_salir = $CanvasLayer/VBoxContainer/boton_salir

func _ready() -> void:
	$ConfirmarSalida.visible = false

func _on_boton_jugar_button_up() -> void:
	$menu_animacion.play("menu")
	boton_jugar.visible = false
	boton_instrucciones.visible = false
	boton_salir.visible = false

func _on_menu_animacion_animation_finished(anim_name):
	if anim_name == "menu":
		get_tree().change_scene_to_file("res://escenas/partida.tscn")

func _on_boton_salir_button_up() -> void:
	$ConfirmarSalida.visible = true
	get_tree().paused = true

func _on_boton_opciones_button_up() -> void:
	pass # Replace with function body.
