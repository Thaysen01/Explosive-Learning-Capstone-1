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


var ishalf = false
var partition_num = 0
var spawn = 4
var newTank_index = 0
var num_newTank = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists("user://questions.json"):
		print(FileAccess.file_exists("res://assets/questions.json"))
	_addCurrentLevel()
	spawn_tanks()



func spawn_tanks():
	print("spawn tanks")
	var split = ceili(Global.total_questions/8)
	var half = ceili(split/2)
	if float(Global.num_correct_answer)/float(Global.total_questions) == 0:
		spawn = 4
		newTank_index = 1
		num_newTank = 1
	elif Global.num_correct_answer % split == 0 and not ishalf:
		ishalf = true
		partition_num += 1
		spawn = 4
		newTank_index += 1
		num_newTank = 1
	
	elif Global.num_correct_answer % half == 0 and  ishalf:
		ishalf = false
		partition_num += 1
		spawn = 6
		newTank_index += 1
		num_newTank = 2
	
		
	var rand_spawn = []
	while rand_spawn.size() != spawn:
		var select = $Spawn.get_children().pick_random()
		if(Global.p1Position != select.position) and rand_spawn.find(select) == -1:
			rand_spawn.append(select)
	var slice_tank = enemytanks.slice(0, newTank_index)
	var tank_spawn = []
	for x in range(num_newTank):
		tank_spawn.append(slice_tank[-1])
	while tank_spawn.size() != spawn:
		tank_spawn.append(slice_tank.pick_random())
	
	for x in range(spawn):
		var tank = tank_spawn[x].instantiate()
		$TileMap.add_child(tank)
		tank.position = rand_spawn[x].position
		
			
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.connect("killed", $TileMap.checkIfAllEnemiesKilled)
		
func nextLevel():
	$CanvasLayer/Banner._lower_banner()
	#spawn_tanks()

func restartLevel():
	get_tree().quit()

func _addCurrentLevel():
	$TileMap.connect("enemies_killed",  self.nextLevel)
	$TileMap.connect("player_died", self.restartLevel)


