extends CharacterBody2D
class_name EnemyBase

@onready var anim = $anim
@export var SPEED = 600.0
@export var enemy_point := 100

var enemy_vision 
var enemy_texture 
var DIRECTION := -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_spawn = false
var spawn_instance: PackedScene = null
var spawn_instance_position


func _apply_gravity(delta):
	#Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

func movement(delta):
	velocity.x = DIRECTION * SPEED * delta
	move_and_slide()

func flip_direction():
	if enemy_vision.is_colliding():
		DIRECTION = -DIRECTION
		enemy_vision.scale.x *= -1
		enemy_texture.scale.x *= -1

func kill_ground_enemy(anim_name: StringName) -> void:
	kill_and_score()
		
func kill_air_enemy() -> void:
	kill_and_score()
	
func kill_and_score():
	Globals.score += enemy_point
	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()
	
func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	get_tree().root.add_child(instance_scene)
	instance_scene.global_position = spawn_instance_position.global_position


