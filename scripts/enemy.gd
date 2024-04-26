extends CharacterBody2D


@onready var enemy_vision = $enemy_vision as RayCast2D
@onready var enemy_texture = $texture as Sprite2D
@onready var anim = $anim as AnimationPlayer
@export var SPEED = 600.0

var DIRECTION := -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if enemy_vision.is_colliding():
		DIRECTION = -DIRECTION
		enemy_vision.scale.x *= -1
		enemy_texture.scale.x *= -1
		
	velocity.x = DIRECTION * SPEED * delta
	move_and_slide()


func _on_anim_animation_finished(anim_name):
	if anim_name == "hurt":
		print("acabou de tocar hurt")
		queue_free()
