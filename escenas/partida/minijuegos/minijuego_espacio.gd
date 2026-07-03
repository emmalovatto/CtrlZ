extends Control

@onready var cuenta = $PanelContainer/VBoxContainer/cuenta_regresiva
@onready var instrucciones = $PanelContainer/VBoxContainer/instrucciones
@onready var minijuego = $PanelContainer/minijuego
@onready var cant_veces = $PanelContainer/minijuego/cant_veces
@onready var tiempo_rest = $PanelContainer/minijuego/tiempo_rest

var cant_restante = 20
var tiempo_restante = 5
var juego_activo = false

signal ganado
signal perdido

func _ready() -> void:
	iniciar_cuenta()

func iniciar_cuenta() -> void:
	cuenta.visible = true
	instrucciones.visible = true
	minijuego.visible = false
	
	instrucciones.text = "Presione ESPACIO 20 veces antes que termine el tiempo"
	cuenta.text = "3"
	await get_tree().create_timer(1.0).timeout
	cuenta.text = "2"
	await get_tree().create_timer(1.0).timeout
	cuenta.text = "1"
	await get_tree().create_timer(1.0).timeout
	cuenta.text = "YA!"
	await get_tree().create_timer(0.5).timeout
	
	cuenta.visible = false
	instrucciones.visible = false
	iniciar_juego()
	
func iniciar_juego() -> void:
	minijuego.visible = true
	
	cant_veces.text = str(cant_restante)
	tiempo_rest.text = str(int(tiempo_restante))
	
	juego_activo = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !juego_activo:
		return
	
	tiempo_restante -= delta
	tiempo_rest.text = str(ceil(tiempo_restante))
	
	if tiempo_restante <= 0:
		juego_activo = false
		perder()

func _input(event: InputEvent) -> void:
	if !juego_activo:
		return
	
	if event.is_action_pressed("minijuego_espacio"):
		cant_restante -= 1
		cant_veces.text = str(cant_restante)
		
		if cant_restante <= 0:
			juego_activo = false
			ganar()

func perder() -> void:
	perdido.emit()
	queue_free()
	
func ganar() -> void:
	ganado.emit()
	queue_free()
