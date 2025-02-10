extends TileMap

signal player_died
signal enemies_killed
signal level_start
signal level_end

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.connect("killed", self.checkIfAllEnemiesKilled) 
		#print(e)

var shake_strength = 5  # Maximum shake offset
var shake_duration = 0.3  # How long the shake lasts
var shaking = false

# Shake the screen
func start_shake(shake_strength: float = 5.0, duration: float = 0.3):
	shake_duration = duration
	shaking = true
	call_deferred("_start_shake")  # Defer the shake to ensure it's done after the current frame

func _start_shake():
	# Using a Timer to control shake duration
	var timer = Timer.new()
	add_child(timer)  # Add the timer to the node tree
	timer.wait_time = shake_duration
	timer.one_shot = true
	timer.start()
	
	# Connect the timer's timeout signal to stop shaking
	timer.connect("timeout", Callable(self, "_on_shake_timeout"))

func _on_shake_timeout():
	shaking = false
	position = Vector2.ZERO  # Reset position after shake

func _process(delta):
	# Player direction
	if (get_node_or_null("PlayerTank")):
		var tankDirection
		if (Input.is_action_pressed("up") && Input.is_action_pressed("right")):
			tankDirection = $PlayerTank.directions.UP_RIGHT
		elif (Input.is_action_pressed("down") && Input.is_action_pressed("left")):
			tankDirection = $PlayerTank.directions.DOWN_LEFT
		elif (Input.is_action_pressed("up") && Input.is_action_pressed("left")):
			tankDirection = $PlayerTank.directions.UP_LEFT
		elif Input.is_action_pressed("down") && Input.is_action_pressed("right"):
			tankDirection = $PlayerTank.directions.DOWN_RIGHT
		elif Input.is_action_pressed("up") :
			tankDirection = $PlayerTank.directions.UP
		elif Input.is_action_pressed("down"):
			tankDirection = $PlayerTank.directions.DOWN
		elif Input.is_action_pressed("left"):
			tankDirection = $PlayerTank.directions.LEFT
		elif Input.is_action_pressed("right"):
			tankDirection = $PlayerTank.directions.RIGHT

		if tankDirection:
			$PlayerTank.move(delta, tankDirection)
	
		if Input.is_action_just_pressed("click"):
			$PlayerTank.tryToShoot()
	
		if Input.is_action_just_pressed("plant_mine"):
			$PlayerTank.tryToPlantMine()
	
	# Screen shaking
	if shaking:
		position = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)


func checkIfAllEnemiesKilled():
	#print("checking enemies")
	var enemies = get_tree().get_nodes_in_group("enemy").size()
	if (enemies == 0):
		#print(get_parent().name)
		if (get_parent().name == "Main"):
			deleteAllBullets()
			deleteAllMines()
			var nextLevel_timer = Timer.new()
			nextLevel_timer.wait_time = .5
			nextLevel_timer.autostart = true
			nextLevel_timer.one_shot = true
			nextLevel_timer.connect("timeout",  self._on_nextLevel_timer_timeout) 
			call_deferred("add_child", nextLevel_timer)
			
		else:
			get_tree().quit()

func _on_nextLevel_timer_timeout():
	#print("timed out")
	if (get_parent().name == "Main"):
		emit_signal("enemies_killed")
	else:
		get_tree().quit()


func _on_PlayerTank_player_dies():
	deleteAllBullets()
	#get_tree().quit()
	deleteAllMines()

	var death_timer = Timer.new()
	death_timer.wait_time = .5
	death_timer.autostart = true
	death_timer.connect("timeout", self._on_death_timer_timeout) 
	add_child(death_timer)
	
	emit_signal("level_end")

func _on_death_timer_timeout():
	if (get_parent().name == "Main"):
		emit_signal("player_died")
	else:
		get_tree().quit()

func deleteAllBullets():
	for node in get_children():
		if(node is Bullet): 
			node.queue_free()

func deleteAllMines():
	var i = 0
	var root = get_tree().root
	var player_tank = get_node("PlayerTank")
	# Access the liveMines array from PlayerTank
	if player_tank:
		while i < player_tank.liveMines.size():
			var mine = player_tank.liveMines[i]
			if is_instance_valid(mine):  # Ensure mine is still valid before freeing
				mine.queue_free()  # Free the mine object
				i += 1  # Only increment i if no element was erased
			else:
				player_tank.liveMines.erase(mine)
		player_tank.liveMines.clear()  # Empty the list after removing mines
