extends CharacterBody2D

@onready var anim = $anim

var move_speed := 50
var direction := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3).timeout
	queue_free()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += move_speed * direction * delta

func set_direction(dir):
	direction = dir
	if dir < 0:
		$anim.flip_h = true
	else:
		$anim.flip_h = false
