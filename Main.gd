extends Node2D

#var GrayTank = preload("res://tanks/GrayTank.tscn") 
var enemytanks = []
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var tankdir = DirAccess.open("res://tanks/EnemyTanks")
	#levelsdir.open("res://scenes//levels")
	tankdir.list_dir_begin()
	var levelStringFormat = tankdir.get_current_dir() + "/%s"
	var tank = tankdir.get_next()
	while(tank != ""):
		var levelString = levelStringFormat % tank
		var loadedLevel = load(levelString)
		enemytanks.append(loadedLevel)
		tank = tankdir.get_next()
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
		print(x.position)
		var rand_tank = enemytanks[rng.randi_range(0, enemytanks.size() - 1)]
		var tank = rand_tank.instantiate()
		$TileMap.add_child(tank)
		tank.position = x.position
		break
			
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.connect("killed", $TileMap.checkIfAllEnemiesKilled)

func nextLevel():
	print("next level")
	spawn_tanks()

func restartLevel():
	get_tree().quit()

func _addCurrentLevel():
	$TileMap.connect("enemies_killed",  self.nextLevel)
	$TileMap.connect("player_died", self.restartLevel)
