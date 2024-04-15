extends Control


var items = load_json_file("res://assets/questions.json")
@onready var question = $bannerImage/VBoxContainer/Question
@onready var animator = $AnimationPlayer
var answer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#------------Slide Down Animation Call------------#

func _lower_banner():
	new_question()
	animator.play("slide_down");
	

func _on_line_2d__time_to_die():
	print("reached time to die");
	_lower_banner();


func _on_slide_down_timer_timeout():
	_lower_banner();
	

func _on_animation_player_animation_finished(anim_name):
	animator.stop(true);
	

func slide_up():
	await get_tree().create_timer(1).timeout
	print("selected");
	animator.play_backwards("slide_down",-1);


#------------Loading the queestions------------#
func new_question():
	var index = randi() % 547
	var item = items.questions
	var questionTest = item[index].text
	answer = item[index].correct_option
	print(answer)
	get_node("VBoxContainer/Question").text = str(questionTest)
	#get_node("ItemList").clear()
	var options = item[index].options
	get_node("VBoxContainer/Option A").text = str(options[0])
	get_node("VBoxContainer/Option B").text = str(options[1])
	get_node("VBoxContainer/Option C").text = str(options[2])
	get_node("VBoxContainer/Option D").text = str(options[3])
	

func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile  = FileAccess.open(filePath, FileAccess.READ);
		var parsedResults = JSON.parse_string(dataFile.get_as_text());
		print(dataFile);
		return parsedResults
	else:
		print("File does not exist");


func _on_banner_image_change_question():
	new_question(); # Replace with function body.


func _on_timer_timeout():
	_on_line_2d__time_to_die()
	$Timer.stop()

func check_answer(choice: int):
	print(choice)
	print(answer)
	if (choice == answer[0]):
		print("correct")
		slide_up()
	else:
		print("incorrect")
		slide_up()

func _on_option_a_pressed():
	check_answer(0)


func _on_option_b_pressed():
	check_answer(1)


func _on_option_c_pressed():
	check_answer(2)


func _on_option_d_pressed():
	check_answer(3)
