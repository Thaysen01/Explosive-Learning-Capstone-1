extends Control

var items = load_json_file("res://assets/questions.json")
@onready var question = $bannerImage/Question
@onready var animator = $AnimationPlayer
var answer = 0
var correct = false
var selected = false

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
	await get_tree().create_timer(1).timeout
	print("selected");
	animator.play_backwards("slide_down",-1);	
	$Timer.start()


#Loads a new question
func new_question():
	var index = randi() % 547
	var item = items.questions
	var questionTest = item[index].text
	answer = item[index].correct_option
	print(answer)
	get_node("Question").text = str(questionTest)
	#get_node("ItemList").clear()
	var options = item[index].options
	get_node("VBoxContainer/Option A").text = str(options[0])
	get_node("VBoxContainer/Option B").text = str(options[1])
	get_node("VBoxContainer/Option C").text = str(options[2])
	get_node("VBoxContainer/Option D").text = str(options[3])
	

#Gets data from the JSON file
func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile  = FileAccess.open(filePath, FileAccess.READ);
		var parsedResults = JSON.parse_string(dataFile.get_as_text());
		return parsedResults
	else:
		print("File does not exist");

#Hides the options. Used to show if answer is correct or not. 
func hide_options():
	get_node("VBoxContainer/Option B").hide()
	get_node("VBoxContainer/Option C").hide()
	get_node("VBoxContainer/Option D").hide()

#Shows the options. Used to show if answer is correct or not.  
func show_options():
		get_node("VBoxContainer/Option B").show()
		get_node("VBoxContainer/Option C").show()
		get_node("VBoxContainer/Option D").show()

#Used to test the banner 
func _on_timer_timeout():
	_lower_banner()
	$Timer.stop()

#Checks the answer with their choice
func check_answer(choice: int):
	hide_options()
	if (choice == answer[0]):
		get_node("VBoxContainer/Option A").text = str("Correct")
		correct = true
		slide_up()
	else:
		get_node("VBoxContainer/Option A").text = str("Incorrect")
		slide_up()
	return correct


#Calls check answer when any of the buttons are pressed
func _on_option_a_pressed():
	check_answer(0)

func _on_option_b_pressed():
	check_answer(1)

func _on_option_c_pressed():
	check_answer(2)

func _on_option_d_pressed():
	check_answer(3)
