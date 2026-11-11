extends Node2D


func _ready():
	var partida = load("res://escenas/partida/partida.tscn").instantiate()

	partida.es_demo = true

	get_tree().root.add_child(partida)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = partida
