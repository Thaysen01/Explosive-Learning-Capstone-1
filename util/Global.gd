extends Node

# Constants
const MAX_INT = 9223372036854775807 # 2^63 - 1

# Global variables
var p1Position: Vector2
var total_questions
var num_correct_answer = 0

func _ready():
	process_mode = 3 #Node.PROCESS_MODE_DISABLED# PAUSE_MODE_PROCESS # This node ignores pause so that we can quit anytime

#func _process(_delta):
	#if Input.is_action_just_pressed("quit"):
		#get_node("/root/Main/CanvasLayer/PauseMenu").visible =  not get_node("/root/Main/CanvasLayer/PauseMenu").visible
		#get_tree().paused = not get_tree().paused

