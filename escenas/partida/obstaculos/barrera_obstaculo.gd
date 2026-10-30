extends Area2D

@export var velocidad = 400.0

signal choque_jugador

var jugador_impactado = false

func _process(delta: float) -> void:
	position.y += velocidad * delta
	if position.y > 700:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not jugador_impactado:
		jugador_impactado = true
		choque_jugador.emit()


func _on_collision_shape_2d_tree_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		choque_jugador.emit()
