class_name Bullet extends CharacterBody2D



@export var speed = 200 #150.0
@export var maxRebounds = 1
@export var damage = 1
var currentRebounds

#brown, beige, yellow, teal, green, red, purple, black 
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
	var bulletSoundPath = "res://ui/bulletShot.wav"
	if scene_file_path == "res://bullet/Bullet.tscn":
		if (Global.masterLevel * Global.soundEffectLevel):
			play_sound(bulletSoundPath, (Global.soundEffectLevel*Global.masterLevel * .45 - 60), 3.0) #-15
	elif scene_file_path == "res://bullet/FastBullet.tscn":
		if (Global.masterLevel * Global.soundEffectLevel):
			play_sound(bulletSoundPath, (Global.soundEffectLevel*Global.masterLevel * .51 - 60), 2.0) #-9
		if Global.difficulty == 0 or Global.difficulty == 1:
			damage = 1
		elif Global.difficulty == 2:
			damage = 2
		elif Global.difficulty == 3:
			damage = 3
	elif scene_file_path == "res://bullet/DoubleFastBullet.tscn":
		if (Global.masterLevel * Global.soundEffectLevel):
			play_sound(bulletSoundPath, (Global.soundEffectLevel*Global.masterLevel * .52 - 60), 1.5) #-8
		if Global.difficulty == 0 or Global.difficulty == 1:
			damage = 1
		elif Global.difficulty == 2:
			damage = 3
		elif Global.difficulty == 3:
			damage = 5
	
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


func getCollisionShapeExtents():
	return $CollisionShape2D.shape.extents
	
func getCollisionShape():
	return $CollisionShape2D.shape

func _on_screen_exited():
	queue_free()

# Giving bullet sound its own function to deal with pitch
func play_sound(sound_path: String, volume_db: float, pitch_scale: float):
	var audio_stream = load(sound_path)
	var audio_player = $AudioStreamPlayer
	audio_player.stream = audio_stream
	audio_player.volume_db = volume_db
	audio_player.pitch_scale = pitch_scale
