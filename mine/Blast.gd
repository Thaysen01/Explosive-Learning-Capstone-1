extends Area2D

var damage = 10
var damage_enabled = true

func _ready():
	$AnimationPlayer.play("default")
	var bombSoundPath = "res://ui/bombExplode.wav"
	if damage_enabled:
		get_node("../../").play_sound(bombSoundPath, -10.0)
	else: # play quieter bombs when spawning (different path)
		get_node("../Main").play_sound(bombSoundPath, -25.0)

func _on_Blast_body_entered(body):
	if damage_enabled and body.get_groups().has("destroyable"):
		body.deal_damage(damage)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
