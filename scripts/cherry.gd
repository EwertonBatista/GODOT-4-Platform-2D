extends EnemyBase

func _process(delta):
	_apply_gravity(delta)
	movement(delta)
