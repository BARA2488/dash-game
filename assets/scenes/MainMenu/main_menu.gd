extends Node2D

@onready var camera = $Camera2D

func _ready() -> void:
	camera.make_current()
