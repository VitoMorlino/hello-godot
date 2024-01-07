extends Node

func play_game():
	get_tree().change_scene_to_file("res://overworld.tscn")

func _on_play_button_pressed():
	play_game()

func _on_load_button_pressed():
	Utilities.load_game()
	play_game()

func _on_quit_button_pressed():
	get_tree().quit()

