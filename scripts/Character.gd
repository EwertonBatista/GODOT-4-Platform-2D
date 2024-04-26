extends CharacterBody2D


@export var SPEED: int = 100
var MAX_SPEED: int = 200
@export var JUMP_FORCE: float = -300.0
var IS_JUMPING: bool = false;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1000

@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if IS_JUMPING:
		animation.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		IS_JUMPING = true
	elif is_on_floor():
		IS_JUMPING = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if !IS_JUMPING:
			animation.play("run")
	elif IS_JUMPING:
		animation.play("jump")

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")

	if Input.is_action_pressed("correr"):
		SPEED = move_toward(SPEED, MAX_SPEED, int(SPEED * delta))
	else:
		SPEED = 100
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if body.is_in_group("enemies"):
		#$Camera2D.reparent(self.get_parent(), true)
		queue_free()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
	
