extends CanvasLayer

@onready var barra_sonido = $PanelContainer/VBoxContainer/BarraSonido/HSlider
var volumen = 1.0

func _ready() -> void:
	visible = false
	barra_sonido.value = volumen

func _on_cancelar_button_up() -> void:
	visible = false
	barra_sonido.value = volumen

func _on_guardar_button_up() -> void:
	visible = false
	volumen = barra_sonido.value
