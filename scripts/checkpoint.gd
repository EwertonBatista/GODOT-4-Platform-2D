extends Area2D

@onready var anim = $anim
@onready var marker_2d = $Marker2D

var is_active = false


func _on_body_entered(body):
	if body.name != "Character" or is_active:
		return
	else:
		activate_checkpoint()

func activate_checkpoint():
	is_active = true
	Globals.current_checkpoint = marker_2d
	anim.play("raising")

func _on_anim_animation_finished():
	if anim.animation == "raising":
		anim.play("checked")
