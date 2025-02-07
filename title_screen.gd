class_name titleScreen
extends Control

@onready var start = $MarginContainer/HBoxContainer/VBoxContainer/Start as Button
@onready var quit = $MarginContainer/HBoxContainer/VBoxContainer/Quit as Button
@onready var file = $MarginContainer/HBoxContainer/VBoxContainer/File as Button
@onready var start_game = preload("res://Main.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#This is ran before the game starts to ensure that there is a question set ready ("res://assets/questions.json" by deafault)
	if not FileAccess.file_exists("user://questions.json"):
		var path = "res://assets/questions.json"
		#var script = preload("res://ui/filedialog.gd").new()
		$CreateQuestionSet._on_file_dialog_file_selected(path)
	
	start.button_down.connect(on_start)
	quit.button_down.connect(on_exit)
	file.button_down.connect(on_file)
	

func on_start() -> void:
	get_tree().change_scene_to_packed(start_game)

func on_exit() -> void:
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func on_file():
	$CreateQuestionSet.show()
	$CreateQuestionSet/FileDialog.show()

func _process(_delta):
	pass

func _on_difficulty_pressed():
	Global.difficulty = Global.difficulty + 1
	if Global.difficulty == 0 or Global.difficulty == 5:
		Global.difficulty = 0
		$MarginContainer/HBoxContainer/VBoxContainer/Difficulty.text = "  Difficulty: Beginner"
	elif Global.difficulty == 1:
		$MarginContainer/HBoxContainer/VBoxContainer/Difficulty.text = "  Difficulty: Easy"
	elif Global.difficulty == 2:
		$MarginContainer/HBoxContainer/VBoxContainer/Difficulty.text = "  Difficulty: Standard"
	elif Global.difficulty == 3:
		$MarginContainer/HBoxContainer/VBoxContainer/Difficulty.text = "  Difficulty: Hard"
	elif Global.difficulty == 4:
		$MarginContainer/HBoxContainer/VBoxContainer/Difficulty.text = "  Difficulty: Impossible"
