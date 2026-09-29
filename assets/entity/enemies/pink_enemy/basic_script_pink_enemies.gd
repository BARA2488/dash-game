extends CharacterBody2D

enum State { IDLE, MOVE, DEAD }
var state = State.IDLE

var current_hp := 0.0
@export var MAX_HP := 10.0
@export var speed := 120
var player: Node2D

#поиск пути
@onready var agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	current_hp = MAX_HP
	add_to_group("enemy")
	#поиск игрока
	player = get_node_or_null("player")
	if not player:
		var arr = get_tree().get_nodes_in_group("player")
		if arr.size() > 0:
			player = arr[0]
	#отладка
	if player:
		print("игрок найден")
		change_state(State.MOVE)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# машина состояний
	match state:
		State.IDLE: idle_update(delta)
		State.MOVE: move_update(delta)
		State.DEAD: die_update(delta)

#функция для смены состояния
func change_state(new_state):
	if state == new_state:
		return
	state = new_state

#СОСТОЯНИЯ
func idle_update(delta):
	pass

func move_update(delta):
	agent.target_position = player.global_position
	var next_point = agent.get_next_path_position()
	if next_point == Vector2.ZERO:
		return
	
	var dir = (next_point - global_position).normalized()
	var target_velocity = dir * speed

	velocity = velocity.lerp(target_velocity, 0.05)

	move_and_slide()
	
func die_update(delta):
	queue_free()

func apply_damage(value):
	current_hp -= value
	if current_hp <= 0.0:
		change_state(State.DEAD)
