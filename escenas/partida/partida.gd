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
var monedas = 0

var cliente_escena = preload("res://escenas/partida/personas/cliente.tscn")
var cliente_actual = null
var veredas = [
	280,
	870
]

var escenas_obstaculos = [
	preload("res://escenas/partida/obstaculos/auto_obstaculo.tscn"),
	preload("res://escenas/partida/obstaculos/barrera_obstaculo.tscn")
]

var escenas_minijuegos = [
	preload("res://escenas/partida/minijuegos/minijuego_espacio.tscn")
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
	
	$CanvasLayer/monedas_texto.text = str(monedas)
	
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
	#sonido_choque.play()
	
	#await sonido_choque.finished
	
	#game_over.play()
	
	camion.set_physics_process(false)
	
	$perder.visible = true
	get_tree().paused = true
	
func _on_agarrar_nafta():
	nafta += 10
	nafta = min(nafta, nafta_max)
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta

func _on_timer_obstaculos_timeout() -> void:
	var objeto = escenas_obstaculos.pick_random().instantiate()	
	objeto.position = Vector2(
		carriles.pick_random(),
		-100
	)
	$obstaculos.add_child(objeto)
	objeto.choque_jugador.connect(_on_choque_jugador)
	$timer_obstaculos.wait_time = randf_range(0.8, 2)

func _on_timer_clientes_timeout() -> void:

	var objeto = cliente_escena.instantiate()
	objeto.position = Vector2(
		veredas.pick_random(),
		-100
	)
	if objeto.position.x == 870:
		objeto.rotation_degrees = 180
	$clientes.add_child(objeto)
	
	objeto.cliente_cerca.connect(_on_cliente_cerca)
	objeto.cliente_lejos.connect(_on_cliente_lejos)
	$timer_clientes.wait_time = randf_range(5.0, 12.0)

func _on_timer_nafta_spawn_timeout() -> void:
	var objeto = nafta_escena.instantiate()
	
	objeto.position = Vector2(
		carriles.pick_random(),
		-100
	)
	$obstaculos.add_child(objeto)
	objeto.agarrar_nafta.connect(_on_agarrar_nafta)
	$timer_nafta_spawn.wait_time = randf_range(8.0, 12.0)

func _on_timer_nafta_timeout() -> void:
	#if frenar.playing or $perder.visible:
		#return 
	nafta -= 2
	if nafta < 0:
		nafta = 0
		$perder.visible = true
		get_tree().paused = true
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta

	#musica_juego.stop()
	#$timer_obstaculos.stop()
	#$timer_nafta.stop()
	#velocidad = 0
	#camion.set_physics_process(false)

	#frenar.play()
	#await frenar.finished

	#game_over.play()
	#$perder.visible = true
	#get_tree().paused = true
	#return 	
	
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta

func _on_cliente_cerca(cliente):
	cliente_actual = cliente

func _on_cliente_lejos():
	cliente_actual = null
	
func abrir_minijuego():
	var minijuego = escenas_minijuegos.pick_random().instantiate()
	$minijuego.add_child(minijuego)
	minijuego.ganado.connect(_on_ganado)
	minijuego.perdido.connect(_on_perdido)
	get_tree().paused = true
	minijuego.visible = true
	
func _on_ganado():
	monedas += 1
	$CanvasLayer/monedas_texto.text = str(monedas)
	get_tree().paused = false
	
func _on_perdido():
	get_tree().paused = false
