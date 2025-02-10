extends Area2D

var damage = 10
var damage_enabled = true 

func _ready():
	$AnimationPlayer.play("default")

func _on_Blast_body_entered(body):
	if damage_enabled and body.get_groups().has("destroyable"):
		body.deal_damage(damage)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
