extends Node2D

@onready var title_screen = load("res://title_screen.tscn") as PackedScene

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
	Global.num_correct_answer = 0
	$CanvasLayer/Finish.hide()
	_addCurrentLevel()
	spawn_tanks()

func spawn_tanks():
	print("spawn tanks")
	print(Global.total_questions == Global.num_correct_answer, Global.total_questions , Global.num_correct_answer)
	if Global.total_questions == Global.num_correct_answer:
		player_failed()
	else:
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
			
		$TileMap/PlayerTank.maxBullets = $TileMap/PlayerTank.player_bullets
		$TileMap/PlayerTank.maxMines = $TileMap/PlayerTank.player_mines


func nextLevel():
	$TileMap/PlayerTank.maxBullets = 0
	$TileMap/PlayerTank.maxMines = 0
	$CanvasLayer/Banner._lower_banner()


func player_failed():
	if Global.total_questions == Global.num_correct_answer:
		$CanvasLayer/Finish/Panel/Label.text = "VICTORY"
	else:
		$CanvasLayer/Finish/Panel/Label.text = "DEFEAT"
	$CanvasLayer/Finish.show()
	var finish_wait = Timer.new()
	finish_wait.wait_time = 2
	finish_wait.autostart = true
	finish_wait.one_shot = true
	finish_wait.connect("timeout",  self._on_finish_wait_timeout) 
	
	call_deferred("add_child", finish_wait)
	
func _on_finish_wait_timeout():
	#get_tree().reload_current_scene()
	get_tree().change_scene_to_packed(title_screen)
	#$CanvasLayer/pause_screen._on_quit_wait_timeout()
	

func _addCurrentLevel():
	$TileMap.connect("enemies_killed", self.nextLevel)
	$TileMap.connect("player_died", self.player_failed)


