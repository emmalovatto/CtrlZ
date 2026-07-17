extends Button

@onready var contenido = $contenido
@onready var dibujo = $contenido/tarjeta/dibujo

var imagen
var id_tarjeta
var descubierta = false
var bloqueada = false
var encontrada = false
signal seleccionada(tarjeta)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _pressed():
	if descubierta or bloqueada:
		return
	
	descubierta = true
	contenido.visible = true
	seleccionada.emit(self)
	
func ocultar():
	contenido.visible = false
	descubierta = false

func atributos_tarjeta(textura, id):
	imagen = textura
	id_tarjeta = id
	dibujo.texture = imagen
	descubierta = false
	bloqueada = false
	encontrada = false
	
func marcar_encontrada():
	encontrada = true
	modulate = Color(0.698, 0.357, 0.698, 1.0)
