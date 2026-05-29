extends CharacterBody2D

var velocidad = 300
var limite_izq = 376
var limite_der = 776

func _physics_process(_delta: float) -> void:
	var direccion = Input.get_axis("mover_izquierda", "mover_derecha")
	velocity.x = velocidad * direccion
	move_and_slide()
	
	position.x = clamp(position.x, limite_izq, limite_der)
