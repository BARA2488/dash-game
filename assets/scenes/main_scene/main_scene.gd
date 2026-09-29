extends Node

signal open_door(door_id)
signal close_door(door_id)

var timer := 0.0
var TIME := 5.0

var p: bool = false

func _ready() -> void:
	# Подписываем все двери на сигнал
	for door in get_tree().get_nodes_in_group("doors"):
		connect("open_door", Callable(door, "_on_open"))
		connect("close_door", Callable(door, "_on_close"))
	
	timer = TIME
	
func open_specific_door(door_id: String) -> void:
	emit_signal("open_door", door_id)
	
func close_specific_door(door_id: String) -> void:
	emit_signal("close_door", door_id)

func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta
	else:
		timer = TIME
		p = !p
		if p:
			open_specific_door("door_1")
		else:
			close_specific_door("door_1")
