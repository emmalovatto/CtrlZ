extends Node2D

@export var velocidad = 400.0
@onready var chunk1 = $chunk1
@onready var chunk2 = $chunk2
@onready var camion = $camion
@onready var musica_juego = $MusicaJuego
@onready var game_over = $SonidoGameOver
@onready var sonido_choque = $SonidoChoque
@onready var frenar = $SonidoFrenar
@onready var frenar_pedido = $FrenarPedido
@onready var moneds = $Moneds
@onready var sonido_nafta = $Nafta
@onready var sonido_nafta_baja = $NaftaBaja

@onready var fondo_actual1 = $chunk1/Sprite2D
@onready var fondo_actual2 = $chunk2/Sprite2D
@onready var fondo_nuevo1 = $chunk1/sprite_nuevo
@onready var fondo_nuevo2 = $chunk2/sprite_nuevo

var nafta_baja_reproducida = false

var nafta_escena = preload("res://escenas/partida/obstaculos/nafta.tscn")

#dash
var dash_escena = preload("res://escenas/partida/obstaculos/dash.tscn")
var en_dash = false
#

var nafta_max = 100.0
var nafta = nafta_max
var monedas = 0.0

var cliente_escena = preload("res://escenas/partida/personas/cliente.tscn")
var clientes_sprites = [
	preload("res://sprites/cliente.png"),
	preload("res://sprites/cliente2.png"),
	preload("res://sprites/cliente3.png"),
	preload("res://sprites/cliente4.png")
]
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
	preload("res://escenas/partida/minijuegos/minijuego_espacio.tscn"),
	preload("res://escenas/partida/minijuegos/minijuego_barra.tscn"),
	preload("res://escenas/partida/minijuegos/minijuego_memotest.tscn")
]

var fondos = [
	preload("res://sprites/calle.png"),
	preload("res://sprites/fondo_ciudad.png"),
	preload("res://sprites/fondo_noche.png"),
	preload("res://sprites/fondo_desierto.png")
]
var zona_actual = 0

var velocidades_zona = [400.0, 500.0, 600.0, 700.0]
var velocidad_objetos = 400.0

var altura_chunk:float = 648.0
var limite_izq = 376
var limite_der = 776
var carriles = [
	576,
	406,
	736
]

#dash
var timer_dash: Timer

func _ready() -> void:
	chunk1.position.y = 0.0
	chunk2.position.y = -altura_chunk
	camion.position.x = get_viewport_rect().size.x / 2.0
	camion.position.y = get_viewport_rect().size.y - 120.0
	
	musica_juego.play()
	musica_juego.position.x = -1000
	
	$CanvasLayer/monedas_texto.text = str(monedas)
	
	$CanvasLayer/HBoxContainer/barra_nafta.max_value = nafta_max
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta
	
	randomize()
	tiempo_rand()
	
	#dash
	timer_dash = Timer.new()
	timer_dash.wait_time = 10.0
	timer_dash.autostart = true
	timer_dash.timeout.connect(_on_timer_dash_timeout)
	add_child(timer_dash)

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
		chunk1.position.y = chunk2.position.y - altura_chunk
	if chunk2.position.y >= altura_chunk:
		chunk2.position.y = chunk1.position.y - altura_chunk

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
	
	await sonido_choque.finished
	game_over.play()
	camion.set_physics_process(false)
	partida_terminada()
	
func _on_agarrar_nafta():
	nafta += 10
	nafta = min(nafta, nafta_max)
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta
	
	sonido_nafta.play()
	
	if nafta > nafta_max * 0.2:
		nafta_baja_reproducida = false
	
	#dash
func _on_timer_dash_timeout():
	var libres = []
	for c in carriles:
		var ocupado = false
		for obs in $obstaculos.get_children():
			if abs(obs.position.x - c) < 10.0 and obs.position.y < 50:
				ocupado = true
				break
		if not ocupado:
			libres.append(c)
			
	if libres.size() > 0:
		var dash = dash_escena.instantiate()
		dash.position = Vector2(libres.pick_random(), -100)
		
		aplicar_velocidad_objeto(dash)
		
		$obstaculos.add_child(dash)
		dash.agarrar_dash.connect(_on_agarrar_dash)
	
	#var superpuesto = false
	#for obs in $obstaculos.get_children():
		#if obs.position.x == 576 and obs.position.y < 50:
			#superpuesto = true
			#break
	#if not superpuesto:
		#var dash = dash_escena.instantiate()
		#dash.position = Vector2(576, -100)
		#if en_dash:
			#dash.velocidad *= 2.0
		#$obstaculos.add_child(dash)
		#dash.agarrar_dash.connect(_on_agarrar_dash)
#
func _on_agarrar_dash():
	if en_dash:
		return
		
	en_dash = true
	actualizar_velocidades_durante_dash()

	var colision = camion.get_node_or_null("CollisionShape2D")
	if colision:
		colision.set_deferred("disabled", true)
		
	await get_tree().create_timer(2.0).timeout
	
	en_dash = false
	velocidad = velocidades_zona[zona_actual]

	for objeto in $obstaculos.get_children():
		aplicar_velocidad_objeto(objeto)

	for cliente in $clientes.get_children():
		aplicar_velocidad_objeto(cliente)

	if colision:
		colision.set_deferred("disabled", false)

func _on_timer_obstaculos_timeout() -> void:
	var objeto = escenas_obstaculos.pick_random().instantiate()
		
	objeto.position = Vector2(
		carriles.pick_random(),
		-100
	)
	aplicar_velocidad_objeto(objeto)
	
	$obstaculos.add_child(objeto)
	objeto.choque_jugador.connect(_on_choque_jugador)
	$timer_obstaculos.wait_time = randf_range(0.8, 2)
	
	
func _on_timer_clientes_timeout() -> void:
	var objeto = cliente_escena.instantiate()
		
	objeto.position = Vector2(
		veredas.pick_random(),
		-100
	)
	var sprite = objeto.get_node_or_null("Sprite2D")
	
	if sprite != null:
		sprite.texture = clientes_sprites.pick_random()

	aplicar_velocidad_objeto(objeto)
	
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
	
	aplicar_velocidad_objeto(objeto)

	$obstaculos.add_child(objeto)
	objeto.agarrar_nafta.connect(_on_agarrar_nafta)
	$timer_nafta_spawn.wait_time = randf_range(7.0, 10.0)

func _on_timer_nafta_timeout() -> void:
	nafta -= 2
	if nafta < 0:
		nafta = 0
		partida_terminada()
	$CanvasLayer/HBoxContainer/barra_nafta.value = nafta
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

func cambiar_fondo():
	chunk1.get_node("Sprite2D").texture = fondos[zona_actual]
	chunk2.get_node("Sprite2D").texture = fondos[zona_actual]

func actualizar_zona():
	var nueva_zona = 0

	if monedas >= 200:
		nueva_zona = 3
	elif monedas >= 100:
		nueva_zona = 2
	elif monedas >= 50:
		nueva_zona = 1

	if zona_actual != nueva_zona:
		zona_actual = nueva_zona

		velocidad = velocidades_zona[zona_actual]
		transicionar_fondo()

		for objeto in $obstaculos.get_children():
			aplicar_velocidad_objeto(objeto)

		for cliente in $clientes.get_children():
			aplicar_velocidad_objeto(cliente)

func aplicar_velocidad_objeto(objeto):
	var velocidad_base = objeto.get_meta("velocidad_base", objeto.get("velocidad"))

	if velocidad_base == null:
		return

	objeto.set_meta("velocidad_base", velocidad_base)
	var factor = velocidades_zona[zona_actual] / 400.0

	if en_dash:
		factor *= 2.0
	objeto.set("velocidad", velocidad_base * factor)
	
func actualizar_velocidades_durante_dash():
	velocidad = velocidades_zona[zona_actual] * 2.0

	for objeto in $obstaculos.get_children():
		aplicar_velocidad_objeto(objeto)

	for cliente in $clientes.get_children():
		aplicar_velocidad_objeto(cliente)
		
func transicionar_fondo():
	var nuevo_fondo = fondos[zona_actual]

	fondo_nuevo1.texture = nuevo_fondo
	fondo_nuevo2.texture = nuevo_fondo

	fondo_nuevo1.modulate.a = 0.0
	fondo_nuevo2.modulate.a = 0.0

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		fondo_nuevo1, "modulate:a", 1.0, 1.5
	)
	tween.tween_property(
		fondo_nuevo2, "modulate:a", 1.0, 1.5
	)

	await tween.finished

	fondo_actual1.texture = nuevo_fondo
	fondo_actual2.texture = nuevo_fondo

	fondo_nuevo1.modulate.a = 0.0
	fondo_nuevo2.modulate.a = 0.0

func _on_ganado():
	moneds.play()
	monedas += 50
	actualizar_zona()
	$CanvasLayer/monedas_texto.text = str(monedas)
	get_tree().paused = false
	
func _on_perdido():
	get_tree().paused = false
	
func partida_terminada():
	Puntuaciones.guardar_puntuacion(Puntuaciones.nombre_jugador, monedas)
	$perder.visible = true
	get_tree().paused = true

func _on_timer_monedas_timeout() -> void:
	monedas += 2
	$CanvasLayer/monedas_texto.text = str(monedas)
	actualizar_zona()
