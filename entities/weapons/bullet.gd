extends Area2D

@export var speed = 500
var is_player : bool

func start(pos, is_player_controlled = false):
	position = pos
	is_player = is_player_controlled
	add_to_group('bullets')
	if not is_player:
		add_to_group('enemy_bullets')

func _process(delta):
	position.y += (-speed if is_player else speed) * delta

func _on_area_entered(area):
	if area.is_in_group('enemies'):
		area.explode()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
