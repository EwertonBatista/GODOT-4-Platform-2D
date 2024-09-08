extends Area2D

func _on_body_entered(body: Node2D):
	if body.name == "Character":	
		body.velocity.y = -body.jump_velocity
		get_parent().anim.play("hurt")
