extends "res://assets/entity/enemies/pink_enemy/basic_script_pink_enemies.gd"
func _ready() -> void:
	MAX_HP = 60.0
	speed = 80
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
