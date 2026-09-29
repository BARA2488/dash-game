extends Node2D

func _ready() -> void:
	$warn_center/AnimationPlayer.play("warning_s")
	$Warning/AnimationPlayer.play("warning_roll")
