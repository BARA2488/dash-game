# Bullet.gd
extends Area2D

@export var damage: float = 10.0
@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.RIGHT
var life_time: float = 5.0
var shooter: Node = null
var velocity: Vector2

func _ready() -> void:
	# Повернуть пулю и определить направление
	velocity = direction.normalized() * speed
	connect("body_entered", Callable(self, "_on_body_entered")) #подключение сигнала

func _physics_process(delta: float) -> void:
	position += velocity * delta
	#удаление со временем
	if life_time > 0.0:
		life_time -= delta
	else:
		queue_free()
	
func _on_body_entered(body: Node) -> void:
	if body == shooter:
		return
	if body.has_method("apply_damage"):
		body.apply_damage(damage)
	die()

func die():
	velocity = Vector2.ZERO
	$bullet_sprite.visible = false
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()
