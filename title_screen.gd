class_name titleScreen
extends Control

@onready var start = $MarginContainer/HBoxContainer/VBoxContainer/Start as Button
@onready var quit = $MarginContainer/HBoxContainer/VBoxContainer/Quit as Button
@onready var start_game = preload("res://Main.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#This is ran before the game starts to ensure that there is a question set ready ("res://assets/questions.json" by deafault)
	var path = "res://assets/questions.json"
	var script = preload("res://ui/filedialog.gd").new()
	script._on_file_dialog_file_selected(path)
	
	start.button_down.connect(on_start)
	quit.button_down.connect(on_exit)

func on_start() -> void:
	get_tree().change_scene_to_packed(start_game)

func on_exit() -> void:
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


