extends Area2D

var damage = 10
var damage_enabled = true

func _ready():
	$AnimationPlayer.play("default")
	var bombSoundPath = "res://ui/bombExplode.wav"
	if damage_enabled:
		if (Global.masterLevel * Global.soundEffectLevel):
			get_node("../../").play_sound(bombSoundPath, (Global.soundEffectLevel*Global.masterLevel * .5 - 60)) #-10
	else: # play quieter bombs when spawning (different path)
		if (Global.masterLevel * Global.soundEffectLevel):
			get_node("../Main").play_sound(bombSoundPath, (Global.soundEffectLevel*Global.masterLevel * .35 - 60)) #-25

func _on_Blast_body_entered(body):
	if damage_enabled and body.get_groups().has("destroyable"):
		body.deal_damage(damage)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
