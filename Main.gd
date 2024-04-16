extends Node2D

#brown, beige, yellow, teal, green, red, purple, white, black 
var enemytanks = [
	preload("res://tanks/EnemyTanks/BrownTank.tscn"), 
	preload("res://tanks/EnemyTanks/BeigeTank.tscn"), 
	preload("res://tanks/EnemyTanks/YellowTank.tscn"),
	preload("res://tanks/EnemyTanks/TealTank.tscn"),
	preload("res://tanks/EnemyTanks/GreenTank.tscn"),
	preload("res://tanks/EnemyTanks/RedTank.tscn"),
	preload("res://tanks/EnemyTanks/PurpleTank.tscn"),
	preload("res://tanks/EnemyTanks/BlackTank.tscn")
	]
	
var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists("user://questions.json"):
		print(FileAccess.file_exists("res://assets/questions.json"))
	_addCurrentLevel()

func _unhandled_input(event):
	if event.is_action_pressed("spawn"):
		spawn_tanks() 

#func _physics_process(delta):
	#if (Input.is_action_pressed("spawn")):
		#var bullet = Bullet.instantiate()
		#print($Marker2D.position)


func spawn_tanks():
	for x in $Spawn.get_children():
		#print(x.position)
		var rand_tank = enemytanks[rng.randi_range(0, enemytanks.size() - 1)]
		var tank = rand_tank.instantiate()
		$TileMap.add_child(tank)
		tank.position = x.position
		
			
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.connect("killed", $TileMap.checkIfAllEnemiesKilled)

func nextLevel():

	spawn_tanks()

func restartLevel():
	get_tree().quit()

func _addCurrentLevel():
	$TileMap.connect("enemies_killed",  self.nextLevel)
	$TileMap.connect("player_died", self.restartLevel)


