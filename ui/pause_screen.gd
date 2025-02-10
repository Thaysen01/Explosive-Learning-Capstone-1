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

func _on_quit_wait_timeout():
	get_tree().paused = false
	get_tree().change_scene_to_packed(title_screen)


