extends TextureButton

@export var sonido: Texture2D
@export var silencio: Texture2D

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index("Sfx")
	update_icon()

func _pressed():
	AudioServer.set_bus_mute(bus_index,!AudioServer.is_bus_mute(bus_index))
	update_icon()

func update_icon():
	if AudioServer.is_bus_mute(bus_index):
		texture_normal = silencio
	else:
		texture_normal = sonido
