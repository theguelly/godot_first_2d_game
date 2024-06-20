extends Node2D

@onready var spawn_timer = $SpawnTimer

@export var enemy : PackedScene
@export var spawn_cooldown : float = 0.5
@export var enemy_spawn_per_cooldown : float = 1

var parent_node: Node
var last_spawn = 0

func _ready():
	initialize_connections()

func initialize_connections():
	parent_node = get_parent()
	if not parent_node:
		return

	parent_node.connect('ready', initialize)
	parent_node.connect('spawn_enabled', spawn_enemy)

func initialize():
	position = parent_node.position
	spawn_timer.wait_time = spawn_cooldown

func spawn_enemy(enabled: bool):
	if not enabled:
		spawn_timer.stop()
		return
	var enemy_rows = 1
	for x in enemy_spawn_per_cooldown:
		var enemy_cols = randi_range(1, 9)
		if last_spawn == enemy_cols:
			spawn_enemy(true)
		last_spawn = enemy_cols
		var _position = Vector2(enemy_cols * (16 + 8), 12 * 4 + enemy_rows * 16)
		var enemy_instance = enemy.instantiate()
		parent_node.get_tree().root.add_child(enemy_instance)
		enemy_instance.start(_position)
		if parent_node.has_method('_on_enemy_died'):
			enemy_instance.died.connect(parent_node._on_enemy_died)
	spawn_timer.wait_time = randf_range(spawn_cooldown - 0.1, spawn_cooldown + 0.1)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	spawn_enemy(true)
