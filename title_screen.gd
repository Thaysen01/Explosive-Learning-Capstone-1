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

# Audio
func _on_audio_pressed():
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer.visible = true

func _on_button_pressed():
	$MarginContainer/HBoxContainer/VBoxContainer/Audio/CanvasLayer.visible = false

func _on_select_questions_pressed():
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer.visible = true

func _on_back_pressed():
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer.visible = false

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

var path
var save_path = "user://questions.json"

# Question set Choices
func questionSetSelected(path):
	#print("Creating parced file")
	#If a new JSON file is saved through (FILE DIALOG): then overwrite that
	var dataFile  = FileAccess.open(path, FileAccess.READ)
	var parsedResults = JSON.parse_string(dataFile.get_as_text())
	dataFile.close()
	var file_access = FileAccess.open(save_path, FileAccess.WRITE)
	file_access.store_line(JSON.stringify(parsedResults))
	file_access.close()
	
	var parent_node = get_node("MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer")
	for child in parent_node.get_children():
		child.modulate.a = 1
	parent_node = get_node("MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer2")
	for child in parent_node.get_children():
		child.modulate.a = 1
	get_node("MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/defaultQs").modulate.a = 1
	#$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer.visible = false

func _on_art_pressed():
	path = "res://assets/art_quiz.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer/art.modulate.a = 0.5
	Global.pauseNameQs = "Art"

func _on_state_pressed():
	path = "res://assets/state_capital_quiz.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer/state.modulate.a = 0.5
	Global.pauseNameQs = "State Capitals"

func _on_math_pressed():
	path = "res://assets/math_quiz_easy.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer/math.modulate.a = 0.5
	Global.pauseNameQs = "Math"

func _on_science_pressed():
	path = "res://assets/science_quiz_easy.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer/science.modulate.a = 0.5
	Global.pauseNameQs = "Science"

func _on_spanish_pressed():
	path = "res://assets/spanish_translation_quiz_easy.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer/spanish.modulate.a = 0.5
	Global.pauseNameQs = "Spanish"

func _on_french_pressed():
	path = "res://assets/french_translation_quiz_easy.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer/french.modulate.a = 0.5
	Global.pauseNameQs = "French"

func _on_music_pressed():
	path = "res://assets/music_quiz.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer2/music.modulate.a = 0.5
	Global.pauseNameQs = "Music"

func _on_presidents_pressed():
	path = "res://assets/president_quiz.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer2/presidents.modulate.a = 0.5
	Global.pauseNameQs = "US Presidents"

func _on_adv_math_pressed():
	path = "res://assets/math_quiz_hard.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer2/advMath.modulate.a = 0.5
	Global.pauseNameQs = "Advanced Math"

func _on_adv_science_pressed():
	path = "res://assets/science_quiz_hard.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer2/advScience.modulate.a = 0.5
	Global.pauseNameQs = "Advanced Science"

func _on_adv_spanish_pressed():
	path = "res://assets/spanish_translation_quiz_hard.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer2/advSpanish.modulate.a = 0.5
	Global.pauseNameQs = "Advanced Spanish"

func _on_adv_french_pressed():
	path = "res://assets/french_translation_quiz_hard.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/VBoxContainer2/advFrench.modulate.a = 0.5
	Global.pauseNameQs = "Advanced French"

func _on_default_qs_pressed():
	path = "res://assets/DefaultQuestions500.json"
	questionSetSelected(path)
	$MarginContainer/HBoxContainer/VBoxContainer/SelectQuestions/CanvasLayer/PanelContainer/ColorRect/defaultQs.modulate.a = 0.5
	Global.pauseNameQs = "Assorted"

func _on_label_mouse_entered():
	$Label/CanvasLayer.visible = true

func _on_label_mouse_exited():
	$Label/CanvasLayer.visible = false
