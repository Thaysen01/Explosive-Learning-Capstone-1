extends CharacterBody2D

@export  var speed = 80 #40
@export var rotation_speed = 8.0

var currentDirection: Vector2
var tankRotation = 0.0

@export var maxBullets = 1
@export var maxMines = 0



var liveBullets = []
var liveMines = []


@export var max_hp = 5
@export var current_hp = 5


const Mine = preload("res://mine/Mine.tscn")
@export var bullet_load = preload("res://bullet/Bullet.tscn")


var bulletInstance = bullet_load.instantiate() # A bullet instance to acces some of ithe Bullet class properties

var directions = {
	"UP": Vector2(0,-1),
	"UP_RIGHT": Vector2(1,-1),
	"RIGHT": Vector2(1,0),
	"DOWN_RIGHT": Vector2(1,1),
	"DOWN": Vector2(0,1),
	"DOWN_LEFT": Vector2(-1,1),
	"LEFT": Vector2(-1,0),
	"UP_LEFT": Vector2(-1,-1),
}


func _ready():
	var sb = StyleBoxFlat.new()
	$health.add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("00ff00")
	$health.value = current_hp
	$health.min_value = 0
	$health.max_value = max_hp
	
	
func _physics_process(_delta):
	$health.value = current_hp


func isRotationWithinDeltaForDirection(direction, rotDelta):
	return (tankRotation > direction - rotDelta) && (tankRotation < direction + rotDelta)
	 
func move(delta, direction):
	var rotation_dir = 0
	var rotDelta = rotation_speed * delta

	# Find best direction to rotate towards (direction / -direction)
	var angleToDirection = abs(Vector2(1,0).rotated(tankRotation).angle_to(direction))
	var angleToOppositeDirection = abs(Vector2(1,0).rotated(tankRotation).angle_to(-direction))
	var closerDirection = direction
	if !(min(angleToDirection, angleToOppositeDirection) == angleToDirection):
		closerDirection = -direction	
	
	# Rotate tank towards desired direction if it's not already alligned with it
	# If it is, move towards that direction
	if (!isRotationWithinDeltaForDirection(closerDirection.angle(), rotDelta)):
		if (tankRotation > closerDirection.angle()):
			rotation_dir = -1
		else:
			rotation_dir = 1
		
		# Only one tankRotation is counted
		if (tankRotation > PI):
			tankRotation = -PI + (tankRotation - PI)
		if (tankRotation < -PI):
			tankRotation = PI - (tankRotation + PI)
		
		tankRotation += rotation_dir * rotDelta
		$Body.rotation = (PI/2) + tankRotation
		$CollisionShape2D.rotation = tankRotation

	else:
		$Body.rotation = (PI/2) + closerDirection.angle()
		$CollisionShape2D.rotation = closerDirection.angle()
		currentDirection = direction
		velocity = direction.normalized() * speed
		move_and_slide()#direction.normalized() * speed)



func rotateCannon(angle):
	$Cannon.rotation = angle
	

func shoot():
	var bullet = bullet_load.instantiate()
	var path = $Body.texture.load_path
	var start = path.find("tank")+4
	var length = path.find(".png") - start
	bullet.get_child(0).texture = bullet.bullet_color[path.substr(start, length)]
	bullet.setup(getCannonTipPosition(), Vector2(1,0).rotated($Cannon.rotation))
	get_parent().add_child(bullet)
	liveBullets.append(bullet)

func tryToShoot():
	if (len($Cannon.get_overlapping_bodies()) == 0): # Validate cannon isn't within a wall
		if (Utils.getNumberOfActiveObjects(liveBullets) < maxBullets):
			shoot()
	

func tryToPlantMine():
	if (Utils.getNumberOfActiveObjects(liveMines) < maxMines):
		plantMine()


func plantMine():
	var mine = Mine.instantiate()
	mine.position = position
	get_parent().add_child(mine)
	liveMines.append(mine)

func getCannonTipPosition():
	return position + $Cannon.position + Vector2(35,0).rotated($Cannon.rotation)

func destroy():
	queue_free()
	
	
func deal_damage(d):
	$health/AnimationPlayer.stop()
	$health/AnimationPlayer.clear_queue()
	$health/AnimationPlayer.play("damage_dealt")
	current_hp -= d
	$health.value -= d
	if current_hp <= 0:
		destroy()

func _exit_tree():
	#print(get_parent().get_children())
	bulletInstance.queue_free()
	pass


