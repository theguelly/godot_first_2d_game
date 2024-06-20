extends CharacterBody2D

@onready var screensize = get_viewport_rect().size

@export var speed = 150
@export var shooting_speed_penalty = 0.5
@export var cooldown = 0.5
@export var bullet_scene : PackedScene

var final_speed : float
var player_can_shoot : bool
var current_delta
var move_event
var input = Vector2.ZERO

func _process(delta):
	screensize = get_viewport_rect().size
	input = input.clamp(Vector2(-1, -1), Vector2(1, 1))
	move_and_collide(input * final_speed * delta)
	position = position.clamp(Vector2(16, 16), screensize - Vector2(16, 16))
	process_booster_animation(delta)
	input = input.lerp(Vector2.ZERO, 0.75)

func _notification(event):
	if (event == NOTIFICATION_PREDELETE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	final_speed = speed
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.use_accumulated_input = true
	if event is InputEventMouseMotion and event.relative.length() > 1:
		input = event.relative.normalized()
		if event.relative.x > 0: 
			$Ship.frame = 2
		elif event.relative.x < 0:
			$Ship.frame = 0
	elif event is InputEventScreenDrag and event.relative.length() > 1:
		input = event.relative
		if event.velocity.x > 10:
			$Ship.frame = 2
		elif event.velocity.x < -10:
			$Ship.frame = 0
	else:
		$Ship.frame = 1

func process_booster_animation(delta):
	if input == Vector2.ZERO:
		$Ship.frame = 1
	if $Ship.frame == 0:
		$Ship/Boosters.animation = 'left'
	elif $Ship.frame == 1:
		$Ship/Boosters.animation = 'forward'
	elif $Ship.frame == 2:
		$Ship/Boosters.animation = 'right'

func movement_shooting_penalty():
	if not player_can_shoot:
		$Ship/Boosters.hide()
		final_speed = speed * shooting_speed_penalty
	else:
		$Ship/Boosters.show()
		final_speed = speed

## --------------------------
## Component Callback Section
## --------------------------

## Weapon Component Callback on Shoot Action
func __weapon_component__on_weapon_shoot_callback(weapon_on_cooldown):
	player_can_shoot = not weapon_on_cooldown
