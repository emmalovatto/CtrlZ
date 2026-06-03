extends Area2D

@export var velocidad = 400

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += velocidad * delta
	if position.y > 700:
		queue_free()
