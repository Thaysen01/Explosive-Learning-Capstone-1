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
	set_difficulty_button()
	
	if Global.masterLevel == 0:
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox3.button_pressed = false
	else: 
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox3.button_pressed = true
	if Global.soundEffectLevel == 0:
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox.button_pressed = false
	else: 
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox.button_pressed = true
	if Global.musicLevel == 0:
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox2.button_pressed = false
	else: 
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox2.button_pressed = true
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.value = Global.musicLevel
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar.value = Global.soundEffectLevel
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar3.value = Global.masterLevel

# Checks possible keyboard inputs user if giving
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_F11:
		toggle_fullscreen()

func toggle_fullscreen():
	var window = get_window()
	if window.mode == Window.MODE_WINDOWED:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN  # Fullscreen mode without borders
	else:
		window.mode = Window.MODE_WINDOWED

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
	set_difficulty_button()

func set_difficulty_button():
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

func _on_audio_pressed():
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer.visible = true

func _on_button_pressed():
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer.visible = false

# Audio logic is decent; take (master * volumeUsed) - x to find the prefered decibles
func _on_check_box_3_toggled(toggled_on): # Master Checked
	if $MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox3.button_pressed:
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar3.value = .01
		Global.masterLevel = .01
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar.mouse_filter = Control.MOUSE_FILTER_PASS
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar.modulate.a = 1
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.mouse_filter = Control.MOUSE_FILTER_PASS
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.modulate.a = 1
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox.mouse_filter = Control.MOUSE_FILTER_PASS
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox.modulate.a = 1
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox2.mouse_filter = Control.MOUSE_FILTER_PASS
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox2.modulate.a = 1
	else: # Master Unchecked
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar3.value = 0
		Global.masterLevel = 0
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar.modulate.a = 0.5
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.modulate.a = .5
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox.modulate.a = .5
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox2.modulate.a = .5

func _on_check_box_toggled(toggled_on):
	if $MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox.button_pressed:
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar.value = 1
		Global.soundEffectLevel = 1
	else:
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar.value = 0
		Global.soundEffectLevel = 0

func _on_check_box_2_toggled(toggled_on):
	if $MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox2.button_pressed:
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.value = 1
		Global.musicLevel = 1
	else:
		$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.value = 0
		Global.musicLevel = 0

func _on_h_scroll_bar_3_scrolling():
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox3.button_pressed = true
	Global.masterLevel = float($MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar3.value)

func _on_h_scroll_bar_scrolling():
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox.button_pressed = true
	Global.soundEffectLevel = int($MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar.value)

func _on_h_scroll_bar_2_scrolling():
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/CheckBox2.button_pressed = true
	Global.musicLevel = (int($MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.value))
