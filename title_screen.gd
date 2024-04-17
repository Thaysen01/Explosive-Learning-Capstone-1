class_name titleScreen
extends Control

@onready var start = $MarginContainer/HBoxContainer/VBoxContainer/Start as Button
@onready var quit = $MarginContainer/HBoxContainer/VBoxContainer/Quit as Button
@onready var start_game = preload("res://Main.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start.button_down.connect(on_start)
	quit.button_down.connect(on_exit)
	

func on_start() -> void:
	get_tree().change_scene_to_packed(start_game)

func on_exit() -> void:
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


