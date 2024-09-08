extends CharacterBody2D

const FIREBALL = preload("res://prefabs/fireball.tscn")
var move_speed := 50.0
var direction := 1
var health_points := 3

@onready var sprite = $sprite
@onready var anim = $anim
@onready var fireball_spawn_point = $fireball_spawn_point
@onready var ground_detector = $ground_detector
@onready var player_detector = $player_detector
@onready var timer = $Timer
@onready var hurt_feedback = $sprite/hurt_feedback

enum EnemyState {PATROL, ATTACK, HURT}
var current_state = EnemyState.PATROL
@export var target : CharacterBody2D

func _physics_process(delta):
	match(current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.ATTACK : attack_state()

func _change_state(state):
	current_state = state

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	fireball_spawn_point.position.x *= -1

func spawn_fireball():
	var new_fireball = FIREBALL.instantiate()
	if sign(fireball_spawn_point.position.x) == 1:
		new_fireball.set_direction(1)
	else:
		new_fireball.set_direction(-1)
	add_sibling(new_fireball)
	new_fireball.global_position = fireball_spawn_point.global_position

# STATES

func attack_state():
	anim.play("shooting")
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)
	pass
	
func patrol_state():
	anim.play("running")
	if is_on_wall():
		flip_enemy()
	if not ground_detector.is_colliding():
		flip_enemy()
	velocity.x = move_speed * direction
	
	if player_detector.is_colliding():
		_change_state(EnemyState.ATTACK)
	move_and_slide()

func hurt_state():
	anim.play("hurt")
	hurt_feedback.visible = true
	await get_tree().create_timer(0.3).timeout
	if health_points > 0:
		health_points -= 1
		_change_state(EnemyState.PATROL)
		hurt_feedback.visible = false
	else:
		queue_free()
	
