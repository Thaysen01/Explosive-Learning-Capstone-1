extends Node

# Constants
const MAX_INT = 9223372036854775807 # 2^63 - 1

# Global variables
var p1Position: Vector2
var total_questions: float
var num_correct_answer = 0
var difficulty = 2
var soundEffectLevel = 75.0
var musicLevel = 75.0
var masterLevel = 1.0
var pauseNameQs = "Assorted"

func _ready():
	process_mode = 3 #Node.PROCESS_MODE_DISABLED# PAUSE_MODE_PROCESS # This node ignores pause so that we can quit anytime
