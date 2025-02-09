extends "res://tanks/TankBase/Tank.gd"

#var RayCastUtils = preload("res://util/RayCastUtils.gd")
var RayCastUtils = preload("res://util/RayCastUtils.gd")

var rotationDirection = 1
var cannonRotSpeed = 1.5
@export var bulletsPerSecond = 0.5
var rng = RandomNumberGenerator.new()
var fireRate # calculated based on bulletsPerSecond
var okToShoot = false

var BULLET_RAYCAST_LIST: Array
var DEBUG_BOUNCE_SPOT: Vector2

signal killed

func _ready():
	super()
	if Debug.SHOW_BULLET_RAYCASTS:
		BULLET_RAYCAST_LIST = []
		DEBUG_BOUNCE_SPOT = Vector2(0,0)

	fireRate = rng.randf_range((1/bulletsPerSecond)-(1/bulletsPerSecond)/5, (1/bulletsPerSecond)-(1/bulletsPerSecond)/5)
	rng.randomize()
	$ShootingTimer.wait_time = fireRate

	# Point cannon towards player, but add a +-PI/4 offset so that we arent pointing dead-on towards him but rather close to him instead
	var orientation = [-1,1]
	var vecToPlayer = position.direction_to((Global.p1Position))
	rotationDirection = orientation[rng.randi_range(0,1)]
	$Cannon.rotation = vecToPlayer.rotated(rotationDirection*PI/4).angle()
	

func _physics_process(delta):
	super(delta)
	$Cannon.rotation += delta * rotationDirection * cannonRotSpeed
	if(okToShoot):
		if Debug.SHOW_BULLET_RAYCASTS: BULLET_RAYCAST_LIST.clear()
		var raycastResult = castBullet(getCannonTipPosition(), Vector2(1,0).rotated($Cannon.rotation))
		# A non normalized result indicates the collision happened inside the collider, so we ignore it
		if (raycastResult && raycastResult.normal.is_normalized()):
			if Debug.SHOW_BULLET_RAYCASTS: DEBUG_BOUNCE_SPOT = raycastResult.position
			if(raycastResult.collider.is_in_group('player')):
				tryToShoot()
				okToShoot = false
			
					
	if Debug.SHOW_BULLET_RAYCASTS: 
		queue_redraw()

func _on_ShootingTimer_timeout():
	if (!okToShoot):
		okToShoot = true
	$ShootingTimer.wait_time = fireRate
	
func _draw():
	if Debug.SHOW_BULLET_RAYCASTS:
		for i in BULLET_RAYCAST_LIST:
			draw_line(i[0] - position, i[1] - position, Color.RED, 1)
		draw_circle(DEBUG_BOUNCE_SPOT - position, 1, Color.BLUE)

func castBullet(origin: Vector2, bulletDir):
	var blastMask = 0b01111 # Blast detection occurs on layer 5 (value 4 0b10000), we want to ignore them when casting bullets, so we zero that bit
	return RayCastUtils.castShape(origin, bulletInstance.getCollisionShape(), bulletDir, get_world_2d().direct_space_state, 1000, BULLET_RAYCAST_LIST, [], blastMask)


func destroy():
	remove_from_group("enemy")
	emit_signal("killed")
	super.destroy()
	get_node("../../CanvasLayer/Stats/PanelContainer2/VBoxContainer/Label").text = " Boss   Health: 🖤 0 " # Assume boss died

#func deal_damage(d):
	#current_hp -= d
	#$health.value -= d
	#if current_hp <= 0:
		#destroy()
