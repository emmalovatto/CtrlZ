extends CanvasLayer

@onready var sonido_boton = $AudioStreamPlayer

@onready var button_sfx = $PanelContainer/VBoxContainer/HBoxContainer2/Sfx

@onready var button_music = $AudioStreamPlayer/VBoxContainer/HBoxContainer2/Music

@onready var barra_sonido = $PanelContainer/VBoxContainer/BarraSonido/HSlider
var volumen = 1.0

func _ready() -> void:
	visible = false
	barra_sonido.value = volumen

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
