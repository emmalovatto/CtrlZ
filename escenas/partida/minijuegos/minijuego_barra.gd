extends Control

@onready var cuenta = $PanelContainer/VBoxContainer/cuenta_regresiva
@onready var instrucciones = $PanelContainer/VBoxContainer/instrucciones
@onready var minijuego = $PanelContainer/minijuego
@onready var barra = $PanelContainer/minijuego/barra
@onready var flecha = $PanelContainer/minijuego/flecha
@onready var helado = $PanelContainer/minijuego/helado
@onready var vida1 = $PanelContainer/minijuego/vidas/vida1
@onready var vida2 = $PanelContainer/minijuego/vidas/vida2
@onready var vida3 = $PanelContainer/minijuego/vidas/vida3
@onready var resultado = $PanelContainer/resultado
@onready var mensaje = $PanelContainer/resultado/mensaje
@onready var game_counter = $GameCounter
#@onready var boton_mini_juegos = 

var cant_vidas = 3
var velocidad = 300
var direccion = 1
var principio_barra = 332.0
var final_barra = 822.0
var principio_objetivo = 557.5
var final_objetivo = 597.5
var juego_activo = false

signal ganado
signal perdido

func _ready() -> void:
	game_counter.play()
	iniciar_cuenta()

func iniciar_cuenta() -> void:
	cuenta.visible = true
	instrucciones.visible = true
	minijuego.visible = false
	
	instrucciones.text = "Presione ESPACIO cuando el helado se encuentre en la posición correcta"
	cuenta.text = "3"
	await get_tree().create_timer(1.0).timeout
	cuenta.text = "2"
	await get_tree().create_timer(1.0).timeout
	cuenta.text = "1"
	await get_tree().create_timer(1.0).timeout
	cuenta.text = "YA!"
	await get_tree().create_timer(0.5).timeout
	
	cuenta.visible = false
	instrucciones.visible = false
	iniciar_juego()
	
func iniciar_juego() -> void:
	minijuego.visible = true
	flecha.position.x = principio_barra
	helado.position.x = principio_barra
	juego_activo = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !juego_activo:
		return
	
	flecha.position.x += velocidad * direccion * delta

	if flecha.position.x >= final_barra:
		flecha.position.x = final_barra
		direccion = -1

	elif flecha.position.x <= principio_barra:
		flecha.position.x = principio_barra
		direccion = 1
	
	helado.position.x = flecha.position.x

func _input(event: InputEvent) -> void:
	if !juego_activo:
		return
		
	juego_activo = false
	var tween = create_tween()
	tween.tween_property(
		helado,
		"position:y",
		266,
		0.3
	)
	await tween.finished
	await get_tree().create_timer(0.5).timeout

	if event.is_action_pressed("minijuego_espacio"):		
		if flecha.position.x >= principio_objetivo and flecha.position.x <= final_objetivo:
			pasar_nivel()
		else:
			sacar_vidas()
			
	if cant_vidas > 0 and velocidad <= 700:
			helado.position = Vector2(principio_barra, 220) 
			flecha.position.x = principio_barra
			juego_activo = true
			
func pasar_nivel():
	velocidad += 200
	
	if velocidad > 700:
		ganar()

func sacar_vidas():
	cant_vidas -= 1
	
	if cant_vidas == 2:
		vida1.visible = false
	elif cant_vidas == 1:
		vida2.visible = false
	elif cant_vidas == 0:
		vida3.visible = false
		perder()

func perder() -> void:
	minijuego.visible = false
	resultado.visible = true
	mensaje.text = "ENTREGA FALLIDA"
	await get_tree().create_timer(2.0).timeout
	
	perdido.emit()
	queue_free()
	
func ganar() -> void:
	minijuego.visible = false
	resultado.visible = true
	mensaje.text = "ENTREGA EXITOSA"
	await get_tree().create_timer(2.0).timeout
	
	ganado.emit()
	queue_free()
