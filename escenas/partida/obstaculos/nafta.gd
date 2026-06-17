extends Area2D

@export var velocidad = 400

signal agarrar_nafta

func _process(delta: float) -> void:
	position.y += velocidad * delta
	if position.y > 700:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		agarrar_nafta.emit()
		queue_free()
