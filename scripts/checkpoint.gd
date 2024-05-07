extends Area2D

@onready var anim = $anim

var is_active = false


func _on_body_entered(body):
	if body.name != "Character" or is_active:
		return
	else:
		Globals.current_checkpoint = self
		is_active = true
		anim.play("raising")

func _on_anim_animation_finished():
	if anim.animation == "raising":
		anim.play("checked")
