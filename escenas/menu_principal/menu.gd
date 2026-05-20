extends Control

@onready var boton_jugar = $CanvasLayer/VBoxContainer/boton_jugar
@onready var boton_instrucciones = $CanvasLayer/VBoxContainer/boton_instrucciones
@onready var boton_salir = $CanvasLayer/VBoxContainer/boton_salir
@onready var boton_opciones = $CanvasLayer/boton_opciones
# Cambios con sonido
@onready var musica_menu = $MusicaMenu
@onready var sonido_boton = $SonidoBoton
@onready var sonido_transicion = $Motor
@onready var musica_juego = $MusicaJuego



func _on_musica_menu_finished() -> void:
	musica_menu.play()

func _ready() -> void:
	$ConfirmarSalida.visible = false
	_on_musica_menu_finished()
	musica_menu.play()

func _on_boton_jugar_button_up() -> void:
	$menu_animacion.play("menu")
	boton_jugar.visible = false
	boton_instrucciones.visible = false
	boton_salir.visible = false
	boton_opciones.visible = false
	
	_transicion_audio()

func _transicion_audio() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(musica_menu, "volume_db", -80, 1.0)
	tween.tween_property(musica_menu, "position", 1.0, 1.0)
	
	await tween.finished
	
	sonido_transicion.position = -1.0
	sonido_transicion.play()
	
	var tween_transicion = create_tween()
	tween_transicion.tween_property(sonido_transicion, "position", 1.0, 0.8)
	
	await tween_transicion.finished
	
	musica_juego.volume_db = 0
	musica_juego.position = -1.0
	musica_juego.play()
	
	var tween_musica_juego = create_tween()
	tween_musica_juego.tween_property(musica_juego, "position", 0.0, 1.0)
	
func _on_menu_animacion_animation_finished(anim_name):
	if anim_name == "menu":
		get_tree().change_scene_to_file("res://escenas/partida/partida.tscn")

func _on_boton_salir_button_up() -> void:
	
	$ConfirmarSalida.visible = true
	get_tree().paused = true

func _on_boton_opciones_button_up() -> void:
	$Ajustes.visible = true

func _on_boton_jugar_mouse_entered() -> void:
	sonido_boton.play()

func _on_boton_instrucciones_mouse_entered() -> void:
	sonido_boton.play()

func _on_boton_salir_mouse_entered() -> void:
	sonido_boton.play()

func _on_boton_opciones_mouse_entered() -> void:
	sonido_boton.play()
