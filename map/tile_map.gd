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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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

func checkIfAllEnemiesKilled():
	#print("checking enemies")
	var enemies = get_tree().get_nodes_in_group("enemy").size()
	if (enemies == 0):
		#print(get_parent().name)
		if (get_parent().name == "Main"):
			deleteAllBullets()
			var nextLevel_timer = Timer.new()
			nextLevel_timer.wait_time = 1
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

	var death_timer = Timer.new()
	death_timer.wait_time = 2
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
