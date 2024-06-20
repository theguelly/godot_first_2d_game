extends Node2D

## Attack Speed of Weapon (in seconds)
@export var ATTACK_SPEED : float = 2
## Bullet Scene
@export var bullet_scene : PackedScene
## Flag if the component is used in a player-controlled node or not
@export var is_player : bool = false
@export var autofire : bool = false

var parent_node: Node
var weapon_on_cooldown : bool = false:
	set = on_cooldown_status_change
var attack_speed:
	set = attack_speed_to_cooldown
var bullet_scene_instance

func _ready():
	initialize_connections()

func initialize_connections():
	parent_node = get_parent()
	if not parent_node:
		return
	
	if is_player:
		parent_node.connect('ready', intialize_player_weapon)
	else:
		parent_node.connect('ready', initialize_enemy_weapon)

func intialize_player_weapon():
	initialize_weapon_component()

func initialize_enemy_weapon():
	initialize_weapon_component()

func initialize_weapon_component(attack_speed_value : float = ATTACK_SPEED):
	attack_speed = attack_speed_value
	weapon_on_cooldown = false
	$WeaponCooldown.wait_time = attack_speed

func attack_speed_to_cooldown(value : float):
	attack_speed = 1 / value

func _process(_delta):
	if is_player:
		if autofire or Input.is_action_pressed('shoot'):
			shoot(parent_node.position)
	else:
		pass

func shoot(character_position):
	if weapon_on_cooldown:
		return

	weapon_on_cooldown = true
	$WeaponCooldown.start()
	bullet_scene_instance = bullet_scene.instantiate()
	get_parent().get_tree().root.add_child(bullet_scene_instance)
	bullet_scene_instance.start(character_position + Vector2(0, -8), is_player)

func _on_gun_cooldown_timeout():
	weapon_on_cooldown = false

func on_cooldown_status_change(value):
	weapon_on_cooldown = value
	if is_player and parent_node.has_method('__weapon_component__on_weapon_shoot_callback'):
		parent_node.__weapon_component__on_weapon_shoot_callback(weapon_on_cooldown)
