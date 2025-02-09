extends Control

#var path = "res://assets/questions.json"
#update this to change where the the questions are being imported from

var save_path = "user://questions.json"
#Set folder location for saving to "user"
@onready var items = load_json_file(save_path)
@onready var question = $bannerImage/Question
@onready var animator = $bannerImage/AnimationPlayer
@onready var button = $bannerImage/Answers.get_children()
#var path = "res://assets/questions.json"

signal question_answered

var question_index

var answer = 0
var rng = RandomNumberGenerator.new()

var banner_down

#This should need to run here since we do it (@onready)
#func _ready():
#	items = load_json_file(save_path)

#------------Slide Down Animation Call------------#

#Lowers the banner with a new quetion loaded
func _lower_banner():
	get_node("../../CanvasLayer/Stats/PanelContainer2").visible = false
	new_question()
	animator.play("slide_down")
	banner_down = true

#Stops the animation after finished and unhides the options
func _on_animation_player_animation_finished(anim_name):
	animator.stop(true);
	show_options()

#Slides the banner up when you select an answer
func slide_up():
	var slide_timer = Timer.new()
	slide_timer.wait_time = 1
	slide_timer.autostart = true
	slide_timer.one_shot = true
	slide_timer.connect("timeout",  self._on_slide_timer_timeout)
	banner_down = false
	await get_tree().create_timer(.5).timeout
	
	call_deferred("add_child", slide_timer)



func _on_slide_timer_timeout():
	#print("selected");
	animator.play_backwards("slide_down",-1);	
	emit_signal("question_answered")


# Loads a new question
func new_question():
	#print("Number of questions remaining: ", items.questions.size())
	question_index = rng.randi_range(0, items.questions.size() - 1)
	var item = items.questions
	var questionTest = item[question_index].text
	answer = item[question_index].correct_option

	print("Correct answer for this question: ", answer) # comment all print statements out---
	$bannerImage/Question.text = str(questionTest)

	#get_node("ItemList").clear()
	var options = item[question_index].options
	for i in range(0,4):
		button[i].text = str(options[i])

# Could have default question sets that the user can choose from (I think the game launches with a question set in mind) ---
# Gets data from the JSON file
func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		# If the user file exsists already on the user's computer, run it
		var dataFile  = FileAccess.open(filePath, FileAccess.READ)
		var parsedResults = JSON.parse_string(dataFile.get_as_text())
		dataFile.close()
		# Check to see if the JSON file is in the correct format
		if typeof(parsedResults) == TYPE_DICTIONARY and parsedResults.has("questions") and parsedResults.questions is Array:
			Global.total_questions = parsedResults.questions.size()
		else:
			var main_scene = load("res://main.tscn").instantiate()
			main_scene.player_failed()
			Global.total_questions = 0
		print("Total Questions: ", Global.total_questions)
		return parsedResults
	#else: # If user file doesn't exsist, create it and rerun if statment
		#var script = preload("res://ui/filedialog.gd").new()
		#return script._on_file_dialog_file_selected(path)
		#calls func in filedialog.gd

# Hides the options. Used to show if answer is correct or not. 
func hide_options():
	for i in range(1,4):
		button[i].hide()

# Shows the options. Used to show if answer is correct or not.  
func show_options():
		for i in range(1,4):
			button[i].show()


# Checks the answer with their choice
func check_answer(choice: int):
	hide_options()
	if (choice == answer[0]):
		button[0].text = str("Correct")
		Global.num_correct_answer += 1
		items.questions.pop_at(question_index)
	else:
		button[0].text = str("Incorrect")
	slide_up()

# Calls check answer when any of the buttons are pressed
func _on_option_a_pressed():
	if banner_down:
		check_answer(0)

func _on_option_b_pressed():
	if banner_down:
		check_answer(1)

func _on_option_c_pressed():
	if banner_down:
		check_answer(2)

func _on_option_d_pressed():
	if banner_down:
		check_answer(3)
