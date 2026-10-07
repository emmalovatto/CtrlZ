extends Control

@onready var cuenta = $PanelContainer/VBoxContainer/cuenta_regresiva
@onready var instrucciones = $PanelContainer/VBoxContainer/instrucciones
@onready var minijuego = $PanelContainer/minijuego
@onready var tiempo_texto = $PanelContainer/minijuego/tiempo
@onready var contenedor = $PanelContainer/minijuego/contenedor_tarjetas
@onready var resultado = $PanelContainer/resultado
@onready var mensaje = $PanelContainer/resultado/mensaje
@onready var vida1 = $PanelContainer/minijuego/vidas/vida1
@onready var vida2 = $PanelContainer/minijuego/vidas/vida2
@onready var vida3 = $PanelContainer/minijuego/vidas/vida3
@onready var game_counter = $GameCounter
@onready var sonido_helado = $SonidoMiniJueg
@onready var mini_juego = $MusicMiniJuego
@onready var carta_falsa = $CartaNoEncontrada

var escena_tarjeta = preload("res://escenas/partida/minijuegos/assets/tarjeta_memo.tscn")

var juego_activo = false
var tiempo_restante = 20
var tarjetas_iniciales = 12
var comprobando = false
var cant_vidas = 3
var parejas_encontradas = 0
var total_parejas = 6
var tarjetas = []
var tarjetas_seleccionadas = []

signal ganado
signal perdido

var imagenes = [
	preload("res://sprites/helado.png"),
	preload("res://sprites/nafta.png"),
	preload("res://sprites/auto_obstaculo.png"),
	preload("res://sprites/barrera_obstaculo.png"),
	preload("res://sprites/camion_arriba.png"),
	preload("res://sprites/cliente.png")
]

func _ready() -> void:
	game_counter.play()
	iniciar_cuenta()
	
	await game_counter.finished
	mini_juego.play()

func iniciar_cuenta() -> void:
	cuenta.visible = true
	instrucciones.visible = true
	minijuego.visible = false
	
	instrucciones.text = "Memorice las tarjetas iguales y agrupe las parejas"
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
	
func _process(delta: float) -> void:
	if !juego_activo:
		return
	else:
		tiempo_restante -= delta
		tiempo_texto.text = str(ceil(tiempo_restante))
	
		if tiempo_restante <= 0:
			juego_activo = false
			perder()

func iniciar_juego() -> void:
	minijuego.visible = true
	crear_tarjetas()
	await revelar_tarjetas()
	juego_activo = true
	
		
func crear_tarjetas() -> void:
	for i in range(imagenes.size()):
		tarjetas.append({
			"imagen": imagenes[i],
			"id": i 
		})
		tarjetas.append({
			"imagen": imagenes[i],
			"id": i 
		})
	
	tarjetas.shuffle() 
	
	for carta_info in tarjetas:
		var tarjeta = escena_tarjeta.instantiate()
		contenedor.add_child(tarjeta)
		tarjeta.atributos_tarjeta(
			carta_info.imagen,
			carta_info.id
		)
		tarjeta.seleccionada.connect(_on_tarjeta_seleccionada)

func revelar_tarjetas():
	for tarjeta in contenedor.get_children():
		tarjeta.contenido.visible = true
	
	await get_tree().create_timer(3.0).timeout
	
	for tarjeta in contenedor.get_children():
		tarjeta.contenido.visible = false
		tarjeta.descubierta = false

func _on_tarjeta_seleccionada(tarjeta):
	if comprobando:
		return
	#sonido_helado.play()
	tarjetas_seleccionadas.append(tarjeta)
	if tarjetas_seleccionadas.size() == 2:
		verificar_cartas()

func verificar_cartas():
	comprobando = true
	var tarjeta1 = tarjetas_seleccionadas[0]
	var tarjeta2 = tarjetas_seleccionadas[1]
	bloquear_tarjetas()
	carta_falsa.play()
	

	if tarjeta1.id_tarjeta == tarjeta2.id_tarjeta:
		tarjeta1.marcar_encontrada()
		tarjeta2.marcar_encontrada()
		
		sonido_helado.play()
		
		tarjeta1.encontrada = true
		tarjeta2.encontrada = true
		
		parejas_encontradas += 1
		
		if parejas_encontradas == total_parejas:
			ganar()

	else:
		await get_tree().create_timer(1.0).timeout
		tarjeta1.ocultar()
		tarjeta2.ocultar()
		sacar_vidas()

	tarjetas_seleccionadas.clear()
	desbloquear_tarjetas()
	comprobando = false
	
func bloquear_tarjetas():
	for tarjeta in contenedor.get_children():
		tarjeta.bloqueada = true

func desbloquear_tarjetas():
	for tarjeta in contenedor.get_children():
		if !tarjeta.encontrada:
			tarjeta.bloqueada = false

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
