extends Node2D

@export var velocidad = 400
@onready var chunk1 = $chunk1
@onready var chunk2 = $chunk2

var altura_chunk = 648

func _ready() -> void:
	pass # Replace with function body.


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
