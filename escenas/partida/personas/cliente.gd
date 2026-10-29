extends Area2D

@export var velocidad = 400.0
@onready var dialogo_lejos = $dialogo_lejos
@onready var dialogo_cerca = $dialogo_cerca

signal cliente_cerca(cliente)
signal cliente_lejos()

func _ready() -> void:
	dialogo_lejos.visible = true
	dialogo_cerca.visible = false
	
func _process(delta):
	position.y += velocidad * delta
	dialogo_lejos.global_rotation = 0
	dialogo_cerca.global_rotation = 0
	if position.y > 700:
		queue_free() 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		dialogo_lejos.visible = false
		dialogo_cerca.visible = true
		cliente_cerca.emit(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		dialogo_lejos.visible = true
		dialogo_cerca.visible = false
		cliente_lejos.emit()
