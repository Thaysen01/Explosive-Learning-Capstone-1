extends Control

@onready var title_screen = load("res://title_screen.tscn") as PackedScene
# Called when the node enters the scene tree for the first time.

func _ready():
	# Update pause display
	if Global.difficulty == 0:
		$PanelContainer/VBoxContainer/Label.text = "Difficulty: Beginner"
	elif Global.difficulty == 1:
		$PanelContainer/VBoxContainer/Label.text = "Difficulty: Easy"
	elif Global.difficulty == 2:
		$PanelContainer/VBoxContainer/Label.text = "Difficulty: Standard"
	elif Global.difficulty == 3:
		$PanelContainer/VBoxContainer/Label.text = "Difficulty: Hard"
	elif Global.difficulty == 4:
		$PanelContainer/VBoxContainer/Label.text = "Difficulty: Impossible"
	$PanelContainer/VBoxContainer/Label2.text = "Questions: " + Global.pauseNameQs

	if Global.masterLevel == 0:
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox3.button_pressed = false
	else: 
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox3.button_pressed = true
	if Global.soundEffectLevel == 0:
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox.button_pressed = false
	else: 
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox.button_pressed = true
	if Global.musicLevel == 0:
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox2.button_pressed = false
	else: 
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox2.button_pressed = true
	$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.value = Global.musicLevel
	$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar.value = Global.soundEffectLevel
	$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar3.value = Global.masterLevel

func resume():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().paused = false
	
	$AnimationPlayer.play_backwards("blur")
	$"../Banner".visible = true

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$"../Banner".visible = false
	$AnimationPlayer.play("blur")
	$"PanelContainer/VBoxContainer/EnemyTanksA".visible = false
	$"PanelContainer/VBoxContainer/EnemyTanksB".visible = false
	$"PanelContainer/VBoxContainer/Controls".visible = false
	$"PanelContainer/VBoxContainer/ControlsB".visible = false
	$PanelContainer/VBoxContainer/tanks.text = "Display Tanks / Controls"

# Checks possible keyboard inputs user if giving
func _unhandled_input(event):
	if event.is_action_pressed("esc") and !get_tree().paused:
		pause()
	elif event.is_action_pressed("esc") and get_tree().paused:
		$PanelContainer/VBoxContainer/CanvasLayer.visible = false
		if (Global.masterLevel * Global.musicLevel):
			get_node("../../AudioStreamPlayer2").volume_db = (Global.musicLevel*Global.masterLevel  * .4) - 60 #-20
		else:
			get_node("../../AudioStreamPlayer2").volume_db = -100
		resume()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F11:
		toggle_fullscreen()

# Repeated full screen function logic from title screen
func toggle_fullscreen():
	var window = get_window()
	if window.mode == Window.MODE_WINDOWED:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN  # Fullscreen mode without borders
	else:
		window.mode = Window.MODE_WINDOWED

func _on_resume_pressed():
	resume()

# Restarts the game from level 1
func _on_restart_pressed():
	resume()
	var buffer_wait = Timer.new()
	buffer_wait.wait_time = 0.4
	buffer_wait.autostart = true
	buffer_wait.one_shot = true
	buffer_wait.connect("timeout",  self._on_buffer_wait_timeout) 
	
	call_deferred("add_child", buffer_wait)

func _on_buffer_wait_timeout():
	get_tree().reload_current_scene()


func _on_quit_pressed():
	$AnimationPlayer.play_backwards("blur")
	var quit_wait = Timer.new()
	quit_wait.wait_time = 0.4
	quit_wait.autostart = true
	quit_wait.one_shot = true
	quit_wait.connect("timeout",  self._on_quit_wait_timeout)
	
	call_deferred("add_child", quit_wait)

# Displays what the tanks abilites are
func _on_tanks_pressed():
	if $"PanelContainer/VBoxContainer/EnemyTanksA".visible == false:
		$"PanelContainer/VBoxContainer/EnemyTanksA".visible = true
		$"PanelContainer/VBoxContainer/EnemyTanksB".visible = true
		$"PanelContainer/VBoxContainer/Controls".visible = false
		$"PanelContainer/VBoxContainer/ControlsB".visible = false
		$PanelContainer/VBoxContainer/tanks.text = "(Tanks) Display Controls"
	else:
		$"PanelContainer/VBoxContainer/EnemyTanksA".visible = false
		$"PanelContainer/VBoxContainer/EnemyTanksB".visible = false
		$"PanelContainer/VBoxContainer/Controls".visible = true
		$"PanelContainer/VBoxContainer/ControlsB".visible = true
		$PanelContainer/VBoxContainer/tanks.text = "(Controls) Display Tanks"

func _process(delta):
	var cannon = $PanelContainer/VBoxContainer/EnemyTanksA/CannonSprite
	var cannonPos = cannon.global_position  # Get the global position of the cannon
	cannon.rotation = cannonPos.angle_to_point(get_global_mouse_position()) + (PI/2)

func _on_quit_wait_timeout():
	get_tree().paused = false
	get_tree().change_scene_to_packed(title_screen)

func _on_audio_settings_pressed():
	$PanelContainer/VBoxContainer/CanvasLayer.visible = true
	#$PanelContainer.visible = false

func _on_h_scroll_bar_value_changed(value):
	Global.soundEffectLevel = int(value)

func _on_h_scroll_bar_2_value_changed(value):
	Global.musicLevel = (int(value))

func _on_h_scroll_bar_3_value_changed(value):
	Global.masterLevel = float(value)

func _on_check_box_3_toggled(toggled_on): # Master Checked
	if $PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox3.button_pressed:
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar3.value = .01
		Global.masterLevel = .01
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar.mouse_filter = Control.MOUSE_FILTER_PASS
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar.modulate.a = 1
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.mouse_filter = Control.MOUSE_FILTER_PASS
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.modulate.a = 1
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox.mouse_filter = Control.MOUSE_FILTER_PASS
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox.modulate.a = 1
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox2.mouse_filter = Control.MOUSE_FILTER_PASS
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox2.modulate.a = 1
	else: # Master Unchecked
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar3.value = 0
		Global.masterLevel = 0
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar.modulate.a = 0.5
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.modulate.a = .5
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox.modulate.a = .5
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox2.modulate.a = .5

func _on_check_box_toggled(toggled_on):
	if $PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox.button_pressed:
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar.value = 1
		Global.soundEffectLevel = 1
	else:
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar.value = 0
		Global.soundEffectLevel = 0

func _on_check_box_2_toggled(toggled_on):
	if $PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox2.button_pressed:
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.value = 1
		Global.musicLevel = 1
	else:
		$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.value = 0
		Global.musicLevel = 0

func _on_h_scroll_bar_3_scrolling():
	$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox3.button_pressed = true
	Global.masterLevel = float($PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar3.value)

func _on_h_scroll_bar_scrolling():
	$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox.button_pressed = true
	Global.soundEffectLevel = int($PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar.value)

func _on_h_scroll_bar_2_scrolling():
	$PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/CheckBox2.button_pressed = true
	Global.musicLevel = (int($PanelContainer/VBoxContainer/CanvasLayer/PanelContainer/ColorRect/HScrollBar2.value))

func _on_back_pressed():
	$PanelContainer/VBoxContainer/CanvasLayer.visible = false
	if (Global.masterLevel * Global.musicLevel):
		get_node("../../AudioStreamPlayer2").volume_db = (Global.musicLevel*Global.masterLevel  * .4) - 60 #-20
	else:
		get_node("../../AudioStreamPlayer2").volume_db = -100
