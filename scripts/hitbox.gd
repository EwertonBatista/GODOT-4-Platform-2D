extends Area2D

func _on_body_entered(body):
	if body.name == "Character":		
		body.velocity.y = body.JUMP_FORCE
		owner.anim.play("hurt")
