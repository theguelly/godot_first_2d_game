extends Area2D

signal died

@export var enemy_bullet_scene : PackedScene

@onready var screensize  = get_viewport_rect().size
@onready var animation_player = $AnimationPlayer
@onready var area_collision = $CollisionShape2D
@onready var shoot_timer = $ShootTimer

var start_position = Vector2.ZERO
var speed = 0
var movement_tween: Tween

func start(_position):
	speed = 50
	position = Vector2(_position.x, -_position.y)
	start_position = _position
	shoot_timer.wait_time = randf_range(0, 5)

func _process(_delta):
	screensize = get_viewport_rect().size

func _physics_process(delta):
	position.y += speed * delta
	if position.y > screensize.y + 32:
		start(start_position)
	if position.x > screensize.x + 32:
		position.x = -16
	if position.x < -32:
		position.x = screensize.x + 16

func explode():
	shoot_timer.stop()
	set_physics_process(false)
	animation_player.play('explode')
	set_deferred('monitoring', false)
	area_collision.set_deferred('disabled', true)
	died.emit(5)
	await animation_player.animation_finished
	queue_free()

func _on_shoot_timer_timeout():
	var enemy_bullet = enemy_bullet_scene.instantiate()
	get_tree().root.add_child(enemy_bullet)
	enemy_bullet.start(position)
	shoot_timer.wait_time = randf_range(0, 10)
	shoot_timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered():
	shoot_timer.start()
