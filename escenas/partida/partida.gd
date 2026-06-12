extends Node2D

@export var velocidad = 400.0
@onready var chunk1 = $chunk1
@onready var chunk2 = $chunk2
@onready var camion = $camion
@onready var musica_juego = $MusicaJuego

var nafta_escena = preload("res://escenas/partida/obstaculos/nafta.tscn")
var nafta_max = 100
var nafta = nafta_max

var escenas_obstaculos = [
	preload("res://escenas/partida/obstaculos/auto_obstaculo.tscn"),
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
	
	$CanvasLayer/barra_nafta.max_value = nafta_max
	$CanvasLayer/barra_nafta.value = nafta
	
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

func tiempo_rand():
	$timer_obstaculos.wait_time = randf_range(1, 2.5)

func _on_choque_jugador():
	$perder.visible = true
	get_tree().paused = true
	
func _on_agarrar_nafta():
	nafta += 10
	nafta = min(nafta, nafta_max)
	$barra_nafta.value = nafta

func _on_timer_obstaculos_timeout() -> void:
	var obstaculo = escenas_obstaculos.pick_random().instantiate()
	obstaculo.choque_jugador.connect(_on_choque_jugador)
	obstaculo.position = Vector2(
		carriles.pick_random(),
		-100
	)
	$obstaculos.add_child(obstaculo)
	

func _on_timer_nafta_timeout() -> void:
	nafta -= 2
	if nafta < 0:
		nafta = 0
		$perder.visible = true
		get_tree().paused = true
	$barra_nafta.value = nafta
	
