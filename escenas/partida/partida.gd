extends Node2D

@export var velocidad = 400.0
@onready var chunk1 = $chunk1
@onready var chunk2 = $chunk2
@onready var musica_juego = $MusicaJuego

var altura_chunk:float = 648.0

func _ready() -> void:
	chunk1.position.y = 0
	chunk2.position.y = -altura_chunk
	musica_juego.play()
	musica_juego.position.x = -1000

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
