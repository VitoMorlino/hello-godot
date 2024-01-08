extends Node


const SAVE_PATH = "user://savegame.bin"


func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"kill_count": Game.number_of_enemy_kills,
		"score": Game.score,
		# "key": value,
		# other saved variables can go here as needed
	}
	var json_string = JSON.stringify(data)
	file.store_line(json_string)
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if file.eof_reached():
			return
		var current_line = JSON.parse_string(file.get_line())
		if current_line:
			Game.number_of_enemy_kills = current_line["kill_count"]
			Game.score = current_line["score"]
		
