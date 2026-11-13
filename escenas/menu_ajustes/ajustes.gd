extends CanvasLayer

@onready var sonido_boton = $AudioStreamPlayer

@onready var boton_opciones_pantalla = $PanelContainer/VBoxContainer/OptionButton

@onready var button_sfx = $PanelContainer/VBoxContainer/HBoxContainer2/Sfx

@onready var button_music = $AudioStreamPlayer/VBoxContainer/HBoxContainer2/Music

@onready var barra_sonido = $PanelContainer/VBoxContainer/BarraSonido/HSlider
var volumen = 1.0

func _ready() -> void:
	visible = false
	barra_sonido.value = volumen
	boton_opciones_pantalla.add_item("1152 x 648")
	boton_opciones_pantalla.add_item("1280 x 720")
	boton_opciones_pantalla.add_item("1920 x 1080")
	
	boton_opciones_pantalla.select(0)

func _on_cancelar_button_up() -> void:
	visible = false
	get_tree().paused = false
	barra_sonido.value = volumen

func _on_guardar_button_up() -> void:
	visible = false
	get_tree().paused = false
	volumen = barra_sonido.value


func _on_cancelar_mouse_entered() -> void:
	sonido_boton.play()


func _on_guardar_mouse_entered() -> void:
	sonido_boton.play()


func _on_sfx_mouse_entered() -> void:
	sonido_boton.play()


func _on_music_mouse_entered() -> void:
	sonido_boton.play()


func _on_layout_opciones_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1152, 648))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
	
