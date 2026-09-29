extends CharacterBody2D

enum State { IDLE, MOVE, DASH, DEAD }
var state = State.IDLE

#движение
var speed = 120
var accel = 1000
var friction = 800
#dash
var dash_speed = 400
var dash_time = 0.1          # длительность рывка
var dash_cooldown = 0.3      # кулдаун
var dash_timer = 0.0
var dash_cd_timer = 0.0
var last_input = Vector2.ZERO
#стрельба
var shoot_cd_timer: float = 0.0
var SHOOT_COOLDOWN: float = 0.1
@export var bullet_scene: PackedScene
#здоровье
@export var current_hp: float = 0.0
@export var MAX_HP: float = 100.0
var dead_processed: bool = false
#телепорт
var player_can_teleport: bool = false
var scene_to_teleport: String

func _ready() -> void:
	current_hp = MAX_HP
	add_to_group("player")

# визуал
func _process(delta):
	if state == State.DEAD:
		return  # отключаем визуальную логику

	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	$main_sprite/head_marker.rotation = dir.angle()
	if Input.is_action_just_pressed("out"):
		apply_damage(50.0)
# логика, которая зависит от фпс
func _physics_process(delta):
	# машина состояний
	match state:
		State.IDLE: idle_update(delta)
		State.MOVE: move_update(delta)
		State.DASH: dash_update(delta)
		State.DEAD: die_update(delta)
	
	#вызов стрельбы
	handle_shooting(delta)
	
	# ТАЙМЕРЫ
	# уменьшаем кулдаун деша
	if dash_cd_timer > 0:
		dash_cd_timer -= delta
	# уменьшаем кулдаун стрельбы
	if shoot_cd_timer > 0:
		shoot_cd_timer -= delta

func change_state(new_state):
	if state == new_state:
		return
	state = new_state

# СОСТОЯНИЯ
func idle_update(delta):
	var input = get_input_vector()
	if input != Vector2.ZERO:
		change_state(State.MOVE)
	if Input.is_action_just_pressed("dash") and dash_cd_timer <= 0:
		start_dash()

func move_update(delta):
	var input = get_input_vector()

	if input != Vector2.ZERO:
		# ускорение к целевой скорости
		var target = input * speed
		velocity = velocity.move_toward(target, accel * delta)
		# запоминание последнего направления движения
		last_input = input
	else:
		# замедление, если игрок отпустил клавиши
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	# переходы FSM
	if input == Vector2.ZERO and velocity.length() < 5:
		change_state(State.IDLE)

	if Input.is_action_just_pressed("dash") and dash_cd_timer <= 0:
		start_dash()

func dash_update(delta):
	dash_timer -= delta
	move_and_slide()
	if dash_timer <= 0:
		dash_cd_timer = dash_cooldown
		change_state(State.MOVE)

func die_update(delta):
	if dead_processed:
		return
	dead_processed = true
	print("умер")

# вспомогательные
func get_input_vector() -> Vector2:
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return dir.normalized()

func start_dash():
	var input = get_input_vector()
	if input == Vector2.ZERO:
		input = last_input # если игрок не нажал wasd, деш в послденню сторону движения
	velocity = input * dash_speed
	dash_timer = dash_time
	change_state(State.DASH)

func apply_damage(value: float):
	if state == State.DEAD:
		return
	
	current_hp -= value
	if current_hp <= 0.0:
		change_state(State.DEAD)
	print("получил урон / root: func aplly_damage IN player_code")
	
#стрельба
func handle_shooting(delta):
	if state == State.DEAD:
		return

	if Input.is_action_pressed("shoot") and shoot_cd_timer <= 0:
		shoot()
		shoot_cd_timer = SHOOT_COOLDOWN

func shoot():
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()

	var bullet = bullet_scene.instantiate()
	bullet.shooter = self #указания, что игрок - стрелок
	bullet.position = $main_sprite/head_marker/bullet_spawner.global_position
	bullet.direction = dir
	bullet.damage = 2.0   # переопределяем базовое значение урона
	bullet.speed = 700   # переопределяем базовое значение скорости
	bullet.rotation = dir.angle()
	get_tree().current_scene.add_child(bullet)

#телепорт между сценами
func try_teleport():
	if player_can_teleport:
		print("телепортирован")
		print(scene_to_teleport) #телепорт в сцену указанную в портале
		await Transition.fade_out()
		get_tree().change_scene_to_file(scene_to_teleport)
	else:
		print("не может быть телепортирован")

func teleport_value(value: bool, scene_root: String):
	player_can_teleport = value
	scene_to_teleport = scene_root
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("apply"):
		try_teleport()
