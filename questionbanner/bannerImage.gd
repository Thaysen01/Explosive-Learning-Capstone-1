extends TextureRect

@onready var animator = $AnimationPlayer

func _lower_banner():
	var node = get_node("res://questionbanner/questionLoad.gd");
	node.new_question()
	animator.play("slide_down");
	

func _on_line_2d__time_to_die():
	print("reached time to die");
	_lower_banner();


func _on_slide_down_timer_timeout():
	_lower_banner();
	

func _on_animation_player_animation_finished(anim_name):
	animator.stop(true);


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	await get_tree().create_timer(1).timeout;
	print("selected");
	animator.play_backwards("slide_down",-1);
