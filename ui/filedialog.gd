extends Node

var save_path = "user://questions.json"
# Called when the node enters the scene tree for the first time.
func _ready():
	$FileDialog.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_file_dialog_file_selected(path):
	print("Creating parced file")
	#If a new JSON file is saved through (FILE DIALOG): then overwrite that
	var dataFile  = FileAccess.open(path, FileAccess.READ)
	var parsedResults = JSON.parse_string(dataFile.get_as_text())
	dataFile.close()
	var file_access = FileAccess.open(save_path, FileAccess.WRITE)
	file_access.store_line(JSON.stringify(parsedResults))
	file_access.close()
	return parsedResults
