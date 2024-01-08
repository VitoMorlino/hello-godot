extends Node

var number_of_enemy_kills = 0
var score = 0

signal game_updated

func change_score_by(amount):
	score += amount
	update_game()
	
func change_killcount_by(amount):
	number_of_enemy_kills += amount
	update_game()
	
func update_game():
	game_updated.emit()
	# check for win conditions
	if score == 40 && number_of_enemy_kills == 2:
		call_deferred("win_game")

func win_game():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://win_screen.tscn")

func reset_game():
	number_of_enemy_kills = 0
	score = 0
