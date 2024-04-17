extends Control

@onready var main_menu = preload("res://Main.tscn") as PackedScene
# Called when the node enters the scene tree for the first time.
#func _ready():
	#hide()

func resume():
	get_tree().paused = false
	
	$AnimationPlayer.play_backwards("blur")
	await get_tree().create_timer(0.4).timeout
	$"../Banner".visible = true

func pause():
	get_tree().paused = true
	$"../Banner".visible = false
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	await get_tree().create_timer(0.4).timeout
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()
