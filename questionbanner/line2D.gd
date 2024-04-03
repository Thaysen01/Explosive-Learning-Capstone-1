extends Line2D

signal _time_to_die;

func _ready():
	$lineTimer.start();

func _decrease():
	points[1].x -= 5;

func _is_die():
	return points[1].x == 0;

func _on_timer_timeout():
	pass
	


func _on_line_timer_timeout():
	_decrease();
	if(_is_die()): 
		emit_signal("_time_to_die");
		$lineTimer.stop();
