extends MarginContainer

func _notification(event):
	if event == NOTIFICATION_WM_GO_BACK_REQUEST:
		process_pause()

func _input(event):
	if event.is_action_pressed('pause'):
		process_pause()

func process_pause():
	if not get_tree().get('paused'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().set_deferred('paused', not get_tree().get('paused'))
