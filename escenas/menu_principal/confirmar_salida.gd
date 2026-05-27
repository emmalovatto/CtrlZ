extends CanvasLayer
@onready var sonido_boton = $SonidoBoton
@onready var sonido_salir = $SonidoSalir

func _ready() -> void:
	visible = false
	
func _on_cancelar_button_up() -> void:
	visible = false
	get_tree().paused = false


func _on_salir_button_up() -> void:
	get_tree().quit()


func _on_cancelar_mouse_entered() -> void:
	sonido_boton.play()


func _on_salir_mouse_entered() -> void:
	sonido_salir.play()
