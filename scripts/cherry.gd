extends EnemyBase


func _ready():
	anim.animation_finished.connect(kill_air_enemy)

func _process(delta):
	_apply_gravity(delta)
	movement(delta)
