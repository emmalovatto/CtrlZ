extends Area2D
#
@export var velocidad = 400.0
signal agarrar_dash
#
func _process(delta: float) -> void:
	position.y += velocidad * delta
	if position.y > 700:
		queue_free()
#
func _on_body_entered(body):
	if body.name == "camion":
		agarrar_dash.emit()
		queue_free()
	#if body.is_in_group("player"):
		#agarrar_dash.emit()
		#queue_free()
