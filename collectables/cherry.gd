extends Area2D

func _on_body_entered(body):
	if body.name == "player_CharacterBody2D":
		collect(body)

func collect(_collector):
	add_motion_to_pickup()
	Utilities.save_game()
	Game.change_score_by(10)
		

func add_motion_to_pickup():
	var tween1 = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	var tween_duration = .15
	tween1.tween_property(self, "position", position - Vector2(0,50), tween_duration)
	tween2.tween_property(self, "modulate:a", 0, tween_duration)
	tween1.tween_callback(queue_free)

