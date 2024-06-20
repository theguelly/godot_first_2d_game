extends MarginContainer

@onready var score_counter = $HBoxContainer/ScoreCounter
@onready var shield_bar = $HBoxContainer/ShieldBar

func update_score(value):
	score_counter.display_digits(value)

func update_shield(max_value, value):
	shield_bar.max_value = max_value
	shield_bar.value = value
