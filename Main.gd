extends Node2D

@onready var title_screen = load("res://title_screen.tscn") as PackedScene

# Enemy tank order: brown, beige, yellow, teal, red, green, purple, black 
var enemytanks = [
	preload("res://tanks/EnemyTanks/BrownTank.tscn"),
	preload("res://tanks/EnemyTanks/BeigeTank.tscn"), 
	preload("res://tanks/EnemyTanks/YellowTank.tscn"),
	preload("res://tanks/EnemyTanks/TealTank.tscn"),
	preload("res://tanks/EnemyTanks/RedTank.tscn"),
	preload("res://tanks/EnemyTanks/GreenTank.tscn"),
	preload("res://tanks/EnemyTanks/PurpleTank.tscn"),
	preload("res://tanks/EnemyTanks/BlackTank.tscn")
	]

var playertank = preload("res://tanks/PlayerTank.tscn")
var Blast = preload("res://mine/Blast.tscn")

var rng = RandomNumberGenerator.new()

var spawn = 4
var newTank_index = 0
var num_newTank = 1
var old_num_correct_answer = -1
var gameOverStarted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	difficulty_adjustments()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) # Mouse cannot drag off screen
	Global.num_correct_answer = 0
	$CanvasLayer/Finish.hide()
	_addCurrentLevel()
	spawn_tanks()

# make sound and music audio mutable (buttons/if trues) ---
# Decides how many new tanks to spawn as well as when to add new tank(s)
func spawn_tanks():
	if Global.num_correct_answer != 0 || Global.num_correct_answer == old_num_correct_answer: # Delay after questions are answered
		await get_tree().create_timer(1.2).timeout
	
	#print("Spawning tanks. Number of correct anwers: ", Global.num_correct_answer)
	if Global.total_questions == Global.num_correct_answer or (Global.num_correct_answer == 14):
		player_failed() # Player wins the game

	else: # Spawn another round of tanks
		# Dealing with if there are more questions than tanks (extra rounds)
		var extras = int(Global.total_questions) % 8
		if Global.total_questions < 8:
			extras = 0
		var split: float = 6.0 / float(extras)
		
		# First wave/level
		if Global.num_correct_answer == 0:
			spawn = 4
			newTank_index = 1
			num_newTank = 1
		elif Global.num_correct_answer != old_num_correct_answer: # Extra rounds (6 tanks)
			if (is_nearest_multiple(newTank_index, split) and spawn != 6): 
				spawn = 6
				num_newTank = 2
			else: # New tank introduced (4 tanks)
				spawn = 4
				newTank_index += 1
				num_newTank = 1
		old_num_correct_answer = Global.num_correct_answer # Save previous question count
		
		# Choosing new and random tank counts
		var rand_spawn = []
		while rand_spawn.size() != spawn:
			var select = $Spawn.get_children().pick_random()
			if(Global.p1Position != select.position) and rand_spawn.find(select) == -1:
				rand_spawn.append(select)
		var slice_tank = enemytanks.slice(0, newTank_index)
		var tank_spawn = []
		for x in range(num_newTank): # Ensures there are atleast 1 (or 2, depending) of the newest tank spawning in
			tank_spawn.append(slice_tank[-1])
		while tank_spawn.size() != spawn: # All other tanks will be random
			if (slice_tank.size() != 8): # Normal level
				tank_spawn.append(slice_tank.pick_random())
			else: # Final level: Only 1 boss
				tank_spawn.append(slice_tank[randi() % 7])
				get_node("AudioStreamPlayer2").pitch_scale = 1.13
		
		for x in range(spawn): # Spawning tanks
			var tank = tank_spawn[x].instantiate()
			$TileMap.add_child(tank)
			tank.position = rand_spawn[x].position
			var enemies = get_tree().get_nodes_in_group("enemy")
			for e in enemies:
				e.connect("killed", $TileMap.checkIfAllEnemiesKilled)
			$TileMap/PlayerTank.maxBullets = $TileMap/PlayerTank.player_bullets
			$TileMap/PlayerTank.maxMines = $TileMap/PlayerTank.player_mines
			
			spawn_blast_animation(tank.position) # Play a fake explosion
			
			var tileMap = $TileMap 
			if (slice_tank.size() != 8): # Normal level
				tileMap.start_shake()
			else: # Final level
				tileMap.start_shake(10.0, 1.3)
	
	# Level display (UI)
	if Global.total_questions > Global.num_correct_answer:
		if Global.total_questions > 13:
			$CanvasLayer/Stats/PanelContainer/VBoxContainer/Label.text = " Level: " + str(Global.num_correct_answer + 1) + " / 14 "
		else:
			$CanvasLayer/Stats/PanelContainer/VBoxContainer/Label.text = " Level: " + str(Global.num_correct_answer + 1) + " / " + str(Global.total_questions) + " "

# Play a fake explosion animation
func spawn_blast_animation(pos: Vector2):
	var blast = Blast.instantiate()
	blast.position = pos
	blast.damage_enabled = false  # Disable damage
	get_parent().add_child(blast)

func difficulty_adjustments():
	# Player Tank
	var current_hp = 100
	if Global.difficulty == 0:
		current_hp = 500
	elif Global.difficulty == 1:
		current_hp = 200
	elif Global.difficulty == 2:
		current_hp = 100
	elif Global.difficulty == 3:
		current_hp = 50
	elif Global.difficulty == 4:
		current_hp = 1
	$TileMap/PlayerTank.current_hp = current_hp

# Checks what the nearest multiple of the split is for extra spawning logic
func is_nearest_multiple(n: int, fraction: float) -> bool:
	var k: int = 1
	var max_value = 6
	while (fraction * k) <= max_value:
		var nearest_int = round(fraction * k)  # Match nearest integer to all mutltiples
		if nearest_int == (n-1): # -1, since going back 1 on divisons
			return true
		k += 1
	return false

func nextLevel():
	$TileMap/PlayerTank.maxBullets = 0
	$TileMap/PlayerTank.maxMines = 0
	$CanvasLayer/Banner._lower_banner()

# Ran for victory or defeat
func player_failed():
	if gameOverStarted == false: # ensures this doesn't get called repeatedly on player death
		gameOverStarted = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_node("AudioStreamPlayer2").playing = false # Main music off
		var tileMap = $TileMap
		var finish_wait = Timer.new()
		if Global.total_questions == 0: # If the question set is invalid
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			play_sound("res://ui/error.wav", -15.0)
			$CanvasLayer/Finish/Panel2.show()
			$CanvasLayer/Finish/Panel.hide()
			$CanvasLayer/Finish/Panel.hide()
			finish_wait.wait_time = 7
		else:
			$CanvasLayer/Finish/Panel.show()
			$CanvasLayer/Finish/Panel2.hide()
			if Global.total_questions == Global.num_correct_answer or (Global.num_correct_answer == 14):
				$CanvasLayer/Finish/Panel/Label.text = "VICTORY"
				play_sound("res://ui/victory.wav", -15.0)
				tileMap.start_shake(0.1, 0.5)
				finish_wait.wait_time = 5
			else:
				get_node("CanvasLayer/Stats/PanelContainer/VBoxContainer/Label2").text = " Health: ❤️ 0 "
				$CanvasLayer/Finish/Panel/Label.text = "DEFEAT"
				play_sound("res://ui/defeat.wav", -20.0)
				tileMap.start_shake(0.2, 4.0)
				finish_wait.wait_time = 4.2
		finish_wait.autostart = true
		finish_wait.one_shot = true
		finish_wait.connect("timeout",  self._on_finish_wait_timeout) 
		$CanvasLayer/Finish.show()
		$CanvasLayer/pause_screen/AnimationPlayer.stop() #still vary rarely shows blur on new games --
		
		call_deferred("add_child", finish_wait)
	
func _on_finish_wait_timeout():
	#get_tree().reload_current_scene()
	get_tree().change_scene_to_packed(title_screen)
	#$CanvasLayer/pause_screen._on_quit_wait_timeout()


func _addCurrentLevel():
	$TileMap.connect("enemies_killed", self.nextLevel)
	$TileMap.connect("player_died", self.player_failed) # runs when game is over

func play_sound(sound_path: String, volume_db: float):
	var audio_stream = load(sound_path)
	var audio_player = $AudioStreamPlayer
	audio_player.stream = audio_stream
	audio_player.volume_db = volume_db
	audio_player.play()
