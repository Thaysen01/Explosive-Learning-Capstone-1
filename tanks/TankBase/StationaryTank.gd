extends "res://tanks/TankBase/EnemyTank.gd"

const maxChangeDirectionTime = 5.0

func _ready():
	super()
	$ChangeDirectionTimer.wait_time = rng.randf_range(0, maxChangeDirectionTime)
	
func _physics_process(delta):
	super(delta)

func _on_ChangeDirectionTimer_timeout():
	rotationDirection = -rotationDirection
	$ChangeDirectionTimer.wait_time = rng.randf_range(0, maxChangeDirectionTime)
