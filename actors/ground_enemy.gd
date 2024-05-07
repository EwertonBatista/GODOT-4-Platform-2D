extends EnemyBase

func _ready():
	enemy_vision = $enemy_vision
	enemy_texture = $texture
	anim.animation_finished.connect(kill_ground_enemy)
	
func _physics_process(delta):
	_apply_gravity(delta)
	movement(delta)
	flip_direction()
	
