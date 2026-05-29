extends Node2D

@export var velocidad = 400.0
@onready var chunk1 = $chunk1
@onready var chunk2 = $chunk2
@onready var camion = $camion
@onready var musica_juego = $MusicaJuego

var cono_escena = preload("res://escenas/partida/obstaculos/cono.tscn")
var altura_chunk:float = 648.0
var limite_izq = 376
var limite_der = 776

func _ready() -> void:
	chunk1.position.y = 0
	chunk2.position.y = -altura_chunk
	camion.position.x = get_viewport_rect().size.x / 2
	camion.position.y = get_viewport_rect().size.y - 120
	
	musica_juego.play()
	musica_juego.position.x = -1000
	
	randomize()
	tiempo_rand()
	

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
	$Timer.wait_time = randf_range(0.5, 1.5)

func _on_timer_timeout() -> void:
	var cono = cono_escena.instantiate()
	cono.position = Vector2(
		randf_range(limite_izq, limite_der),
		-100
	)
	$obstaculos.add_child(cono)
