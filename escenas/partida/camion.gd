extends CharacterBody2D

var velocidad = 300
var limite_izq = 376
var limite_der = 776

@onready var sonido_movimiento = $SonidoMovimiento

func _physics_process(_delta: float) -> void:
	var direccion = Input.get_axis("mover_izquierda", "mover_derecha")
	velocity.x = velocidad * direccion
	move_and_slide()
	
	position.x = clamp(position.x, limite_izq, limite_der)
	
	if direccion != 0:
		if !sonido_movimiento.playing:
			sonido_movimiento.play()
	else:
		sonido_movimiento.stop()
