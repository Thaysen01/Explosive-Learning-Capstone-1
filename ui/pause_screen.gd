extends Control

@onready var title_screen = load("res://title_screen.tscn") as PackedScene
# Called when the node enters the scene tree for the first time.
#func _ready():
	#hide()

# Rework pause screen images --- 
# Show controls in pause menu ---
# Display BOSS stats on screen ---

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

func _unhandled_input(event):
	if event.is_action_pressed("esc") and !get_tree().paused:
		pause()
	elif event.is_action_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	#await get_tree().create_timer(0.4).timeout
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

func _on_tanks_pressed():
	$"PanelContainer/VBoxContainer/EnemyTanksA".visible = true
	$"PanelContainer/VBoxContainer/EnemyTanksB".visible = true
	
func _on_quit_wait_timeout():
	get_tree().paused = false
	get_tree().change_scene_to_packed(title_screen)


