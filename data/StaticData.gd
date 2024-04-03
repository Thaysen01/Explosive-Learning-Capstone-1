extends Node


var itemData

var json_file_path = "res://data/questions.json";

func _ready():
	itemData = load_json_file(json_file_path);

func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile  = FileAccess.open(filePath, FileAccess.READ);
		var parsedResults = JSON.parse_string(dataFile.get_as_text());
		print(dataFile);
		return parsedResults
	else:
		print("File does not exist");
