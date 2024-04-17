extends Control

@onready var items = load_json_file("res://assets/questions.json")
@onready var question = $bannerImage/Question
@onready var animator = $bannerImage/AnimationPlayer
@onready var button = $bannerImage/Answers.get_children()

signal question_answered

var question_index
var answer = 0

var rng = RandomNumberGenerator.new()



#------------Slide Down Animation Call------------#


#Lowers the banner with a new quetion loaded
func _lower_banner():
	new_question()
	animator.play("slide_down")

#Stops the animation after finished and unhides the options
func _on_animation_player_animation_finished(anim_name):
	animator.stop(true);
	show_options()
	

#Slides the banner up when you select an answer
func slide_up():
	#await get_tree().create_timer(1).timeout
	var slide_timer = Timer.new()
	slide_timer.wait_time = 1
	slide_timer.autostart = true
	slide_timer.one_shot = true
	slide_timer.connect("timeout",  self._on_slide_timer_timeout) 
	
	call_deferred("add_child", slide_timer)
	


func _on_slide_timer_timeout():
	print("selected");
	animator.play_backwards("slide_down",-1);	
	emit_signal("question_answered")

#Loads a new question
func new_question():
	print(items.questions.size())
	question_index = rng.randi_range(0, items.questions.size() - 1)
	var item = items.questions
	var questionTest = item[question_index].text
	answer = item[question_index].correct_option
	print(answer)
	$bannerImage/Question.text = str(questionTest)
	#get_node("ItemList").clear()
	var options = item[question_index].options
	for i in range(0,4):
		button[i].text = str(options[i])
	
	

#Gets data from the JSON file
func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile  = FileAccess.open(filePath, FileAccess.READ);
		var parsedResults = JSON.parse_string(dataFile.get_as_text());
		dataFile.close()
		Global.total_questions = parsedResults.questions.size()
		return parsedResults
	else:
		print("File does not exist");

#Hides the options. Used to show if answer is correct or not. 
func hide_options():
	for i in range(1,4):
		button[i].hide()

#Shows the options. Used to show if answer is correct or not.  
func show_options():
		for i in range(1,4):
			button[i].show()



#Checks the answer with their choice
func check_answer(choice: int):
	hide_options()
	if (choice == answer[0]):
		button[0].text = str("Correct")
		slide_up()
		Global.num_correct_answer += 1
		items.questions.pop_at(question_index)
	else:
		button[0].text = str("Incorrect")
		slide_up()


#Calls check answer when any of the buttons are pressed
func _on_option_a_pressed():
	check_answer(0)

func _on_option_b_pressed():
	check_answer(1)

func _on_option_c_pressed():
	check_answer(2)

func _on_option_d_pressed():
	check_answer(3)

