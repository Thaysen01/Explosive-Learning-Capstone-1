extends "res://tanks/TankBase/Tank.gd"
signal player_dies

@onready var player_bullets = maxBullets

func _ready():
	super()
	collision_layer = 2 # Need to set it here as the UI seems to be buggy on 3.4, it always sets it to 1 no mather what you choose

func _physics_process(delta):
	super(delta)
	Global.p1Position = position
	rotateCannon(position.angle_to_point(get_global_mouse_position()))#get_global_mouse_position().angle_to_point(position))
  
func destroy():
	super.destroy()
	emit_signal("player_dies")
	
