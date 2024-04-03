extends Node

@onready var question = $bannerImage/VBoxContainer/Question
@onready var answers = $bannerImage/VBoxContainer/ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	question.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_question():
	var index = randi() % 547
	question.text = "test"
