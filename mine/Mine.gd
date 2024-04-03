extends Node2D

var Blast = preload("res://mine/Blast.tscn")

var armed = false

#func _ready():
	#AudioManager.play(AudioManager.SOUNDS.MINE)

func setup(pos: Vector2):
	self.position = pos

func createBlast():
	var blast = Blast.instantiate()
	blast.position = position
	get_parent().add_child(blast)

func deal_damage(_d):
	destroy()

func destroy():
	call_deferred("createBlast")
	queue_free()

func _on_ExpireTimer_timeout():
	$BlastTimer.start()
	$AnimationPlayer.play("tick")

func _on_BlastTimer_timeout():
	destroy()


func _on_Mine_entered(_body):
	if armed:
		destroy()


func _on_ArmingTimer_timeout():
	armed = true



