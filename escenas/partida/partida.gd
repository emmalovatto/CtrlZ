extends Node2D

@export var velocidad = 400.0
@onready var chunk1 = $chunk1
@onready var chunk2 = $chunk2
@onready var camion = $camion
@onready var musica_juego = $MusicaJuego
@onready var game_over = $SonidoGameOver
@onready var sonido_choque = $SonidoChoque
@onready var frenar = $SonidoFrenar

var nafta_escena = preload("res://escenas/partida/obstaculos/nafta.tscn")
var nafta_max = 100
var nafta = nafta_max

var cliente_escena = preload("res://escenas/partida/personas/cliente.tscn")
var cliente_actual = null
var veredas = [
	250,
	900
]

var escenas_obstaculos = [
	preload("res://escenas/partida/obstaculos/auto_obstaculo.tscn"),
	preload("res://escenas/partida/obstaculos/barrera_obstaculo.tscn")
]
var altura_chunk:float = 648.0
var limite_izq = 376
var limite_der = 776
var carriles = [
	576,
	406,
	736
]

func _ready() -> void:
	chunk1.position.y = 0
	chunk2.position.y = -altura_chunk
	camion.position.x = get_viewport_rect().size.x / 2
	camion.position.y = get_viewport_rect().size.y - 120
	
	musica_juego.play()
	musica_juego.position.x = -1000
	
	$CanvasLayer/HBoxContainer/barra_nafta.max_value = nafta_max
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta
	
	randomize()
	tiempo_rand()

func _on_musica_juego_finished() -> void:
	musica_juego.play()

func transicion_audio() -> void:
	var tween_nivel = create_tween()
	
	tween_nivel.tween_property(
	musica_juego,
	"position:x",
	-1000,
	2.0
	)

func _process(delta: float) -> void:
	chunk1.position.y += velocidad * delta
	chunk2.position.y += velocidad * delta 
	
	if chunk1.position.y >= altura_chunk:
		chunk1.position.y -= altura_chunk * 2
		
	if chunk2.position.y >= altura_chunk:
		chunk2.position.y -= altura_chunk * 2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pausar"):
		get_tree().paused = true
		$pausa.visible = true
	
	if event.is_action_pressed("iniciar_minijuego"):
		if cliente_actual != null:
			abrir_minijuego()

func tiempo_rand():
	$timer_obstaculos.wait_time = randf_range(1, 2.5)

func _on_choque_jugador():
	musica_juego.stop()
	sonido_choque.play()
	game_over.play()
	
	$perder.visible = true
	get_tree().paused = true
	
func _on_agarrar_nafta():
	nafta += 10
	nafta = min(nafta, nafta_max)
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta

func _on_timer_obstaculos_timeout() -> void:
	var objeto 
	var random = randf()
	
	if random < 0.2:
		objeto = cliente_escena.instantiate()
		
		objeto.position = Vector2(
			veredas.pick_random(),
			-100
		)
		$clientes.add_child(objeto)
		objeto.cliente_cerca.connect(_on_cliente_cerca)
		objeto.cliente_lejos.connect(_on_cliente_lejos)
		
	elif random < 0.4:
		objeto = nafta_escena.instantiate()
		
		objeto.position = Vector2(
			carriles.pick_random(),
			-100
		)
		$obstaculos.add_child(objeto)
		objeto.agarrar_nafta.connect(_on_agarrar_nafta)
	else:
		objeto = escenas_obstaculos.pick_random().instantiate()
		
		objeto.position = Vector2(
			carriles.pick_random(),
			-100
		)
		$obstaculos.add_child(objeto)
		objeto.choque_jugador.connect(_on_choque_jugador)
	
func _on_timer_nafta_timeout() -> void:
	nafta -= 2
	if nafta < 0:
		nafta = 0
		$perder.visible = true
		get_tree().paused = true
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta
	
func _on_cliente_cerca(cliente):
	cliente_actual = cliente

func _on_cliente_lejos():
	cliente_actual = null
	
func abrir_minijuego():
	get_tree().paused = true
	$pausa.visible = true
	
