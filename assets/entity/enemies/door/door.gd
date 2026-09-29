extends StaticBody2D

@export var id : String = ""   # можно задать прямо в инспекторе

func _ready() -> void:
	add_to_group("doors")
	$down_door/AnimationPlayer.play("stay")

func _on_open(door_id: String) -> void:
	if door_id == id:
		print("Door %s opened" % id)
		$down_door/AnimationPlayer.play("down_open")
		print("open")

func _on_close(door_id: String) -> void:
	if door_id == id:
		print("Door %s slosed" % id)
		$down_door/AnimationPlayer.play("down_close")
		print("close")
