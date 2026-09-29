extends CanvasLayer
@onready var anim = $AnimationPlayer
var _last_scene: Node = null

func _ready() -> void:
	anim.play("fade_in")
	_last_scene = get_tree().current_scene
	get_tree().tree_changed.connect(_on_tree_changed)

func _on_tree_changed():
	var tree := get_tree()
	if tree == null:
		return
	
	var current = get_tree().current_scene
	if current != _last_scene:
		_last_scene = current
		fade_in()

func fade_out():
	anim.play("fade_out")
	await anim.animation_finished

func fade_in():
	anim.play("fade_in")
	await anim.animation_finished
