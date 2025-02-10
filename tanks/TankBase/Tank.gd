extends CharacterBody2D

@export  var speed = 80 #40
@export var rotation_speed = 8.0

var currentDirection: Vector2
var tankRotation = 0.0

@export var maxBullets = 1
@export var maxMines = 0



var liveBullets = []
var liveMines = []


@export var max_hp = 5 #default value is 5 if unassigned (it wont be)
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
	z_index = 1 # bring the character forward for animation to appear under them
	var sb = StyleBoxFlat.new()
	$health.add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("00ff00")
	
	if scene_file_path == "res://tanks/EnemyTanks/BlackTank.tscn": # Check to see if this is a boss
		get_node("../../CanvasLayer/Stats/PanelContainer2").visible = true # Show boss bar
		# Difficulty Adjustments (boss current_hp, max_hp)
		if Global.difficulty == 0:
			current_hp = 15
			max_hp = 15
		elif Global.difficulty == 1:
			current_hp = 25
			max_hp = 25
		elif Global.difficulty == 2:
			current_hp = 35
			max_hp = 35
		elif Global.difficulty == 3:
			current_hp = 50
			max_hp = 50
		elif Global.difficulty == 4:
			current_hp = 100
			max_hp = 100
	
	# Difficulty Adjustments (player current_hp, max_hp)
	elif scene_file_path == "res://tanks/PlayerTank.tscn":
		# Difficulty Adjustments (max_hp)
		if Global.difficulty == 0:
			current_hp = 500
			max_hp = 500
		elif Global.difficulty == 1:
			current_hp = 200
			max_hp = 200
		elif Global.difficulty == 2:
			current_hp = 100
			max_hp = 100
		elif Global.difficulty == 3:
			current_hp = 50
			max_hp = 50
		elif Global.difficulty == 4:
			current_hp = 1
			max_hp = 1
	$health.min_value = 0
	$health.max_value = max_hp


func _physics_process(_delta):
	$health.value = current_hp
	if scene_file_path == "res://tanks/PlayerTank.tscn":
		get_node("../../CanvasLayer/Stats/PanelContainer/VBoxContainer/Label2").text = " Health: ❤️ " + str($health.value) + " "
	elif scene_file_path == "res://tanks/EnemyTanks/BlackTank.tscn":
		get_node("../../CanvasLayer/Stats/PanelContainer2/VBoxContainer/Label").text = " Boss   Health: 🖤 " + str($health.value) + " "

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
		move_and_slide()



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
	# this does allow for mines to be able to be planted anywhere, 
	# as lng as the cap has not been hit (for mines)


func plantMine():
	var mine = Mine.instantiate()
	mine.position = position
	get_parent().add_child(mine)
	liveMines.append(mine)  # Add the mine to the liveMines list


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


