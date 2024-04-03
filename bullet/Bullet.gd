class_name Bullet extends CharacterBody2D



@export var speed = 200 #150.0
@export var maxRebounds = 1
@export var damage = 1
var currentRebounds

#brown, beige, yellow, teal, green, red, purple, white, black 

var bullet_color ={
	"Blue" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletBlue.png"),
	"Brown" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletBrown.png"),
	"Beige" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletBeige.png"),
	"Yellow" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletYellow.png"),
	"Teal" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletTeal.png"),
	"Green" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletGreen.png"),
	"Red" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletRed.png"),
	"Purple" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletPurple.png"),
	"Black" : preload("res://assets/kenney_top-down-tanks/PNG/Bullets/bulletBlack.png"),
}


# Called when the node enters the scene tree for the first time.

	

func setup(initialPosition: Vector2, initialVelocity: Vector2):
	position = initialPosition
	self.velocity = initialVelocity.normalized()
	currentRebounds = 0
	self.rotation = initialVelocity.angle()


func destroy():
	queue_free()
	
func deal_damage(_d):
	destroy()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity*delta*speed)
	if (collision):
		if(not collision.get_collider() is TileMap):
			if (collision.get_collider().get_groups().has("destroyable")):
				collision.get_collider().deal_damage(damage)
			
		self.destroy()
		#else: # Collision with walls
			#if (currentRebounds >= maxRebounds):
				#queue_free()
			#else: 
				#velocity = velocity.bounce(collision.normal)
				#self.rotation = velocity.angle()
				#currentRebounds += 1;
				


func getCollisionShapeExtents():
	return $CollisionShape2D.shape.extents
	
func getCollisionShape():
	return $CollisionShape2D.shape

func _on_screen_exited():
	queue_free()

