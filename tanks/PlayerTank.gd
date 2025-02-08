extends "res://tanks/TankBase/Tank.gd"
signal player_dies

@onready var player_bullets = maxBullets
@onready var player_mines = maxMines

func _ready():
	# Difficulty Adjustments (maxBullets)
	if scene_file_path == "res://tanks/PlayerTank.tscn":
		if Global.difficulty == 0 or Global.difficulty == 1:
			player_bullets = 10
		elif Global.difficulty == 2 or Global.difficulty == 3 or Global.difficulty == 4:
			player_bullets = 5
	super()
	collision_layer = 2 # Need to set it here as the UI seems to be buggy on 3.4, it always sets it to 1 no mather what you choose


func _physics_process(delta):
	super(delta)
	Global.p1Position = position
	rotateCannon(position.angle_to_point(get_global_mouse_position()))#get_global_mouse_position().angle_to_point(position))
  
func destroy():
	super.destroy()
	emit_signal("player_dies")
	
