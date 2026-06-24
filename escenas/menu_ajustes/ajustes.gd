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


func _on_sfx_pressed() -> void:
	var sfx_bus_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_mute(sfx_bus_index, AudioServer.is_bus_mute(sfx_bus_index))
	
	if AudioServer.is_bus_mute(sfx_bus_index):
		button_sfx.text = "🔇 Sonido"
	else:
		button_sfx.text = "🔊 Sonido"

	


func _on_music_pressed() -> void:
	var musica_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(musica_bus_index, AudioServer.is_bus_mute(musica_bus_index))
	
	if AudioServer.is_bus_mute(musica_bus_index):
		button_music.text = "🔇 Sonido"
	else:
		button_music.text = "🎵 Sonido"
