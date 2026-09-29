extends Node2D

@onready var anim = $AnimationPlayer
var player: Node2D

var can_teleport_player: bool = false
var teleport_timer := 1.0
const TELEPORT_COOLDOWN := 1.0

@export var scene_root: String = "res://assets/entity/circle_teleport/circle_teleport.tscn"

func _physics_process(delta: float) -> void:
	if teleport_timer > 0:
		teleport_timer -= delta
		can_teleport_player = false
	else:
		can_teleport_player = true
	if player:
		if player.has_method("teleport_value"):
			player.teleport_value(can_teleport_player, scene_root)
			
	$Label.text = str("timer: ", teleport_timer)

func _player_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		teleport_timer = TELEPORT_COOLDOWN #КД АКТИВАЦИИ
		anim.play("entry")

func _player_exited(body: Node2D) -> void:
	if body.is_in_group("player") and player == body:
		anim.play("leave")
		if player.has_method("teleport_value"):
			player.teleport_value(false,"none")
		player = null
