extends Area2D

@export var velocidad = 400

signal cliente_cerca(cliente)
signal cliente_lejos()

func _process(delta):
	position.y += velocidad * delta
	
	if position.y > 700:
		queue_free() 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		cliente_cerca.emit(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		cliente_lejos.emit()
