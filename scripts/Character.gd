extends CharacterBody2D


@export var SPEED: int = 100
#@export var JUMP_FORCE: float = -300.0
@export var AIR_FRICTION := 0.5
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var ray_right := $ray_right as RayCast2D
@onready var ray_left := $ray_left as RayCast2D
@onready var timer := $Timer as Timer
@onready var jump_fx = $jump_fx as AudioStreamPlayer
@onready var world_01 = $".."
@onready var rigid_body_2d = $"../RigidBody2D"

# Handle jump and gravity
@export var jump_height := 64
@export var max_time_to_peek := 0.5

var jump_velocity
var gravity = 1000
var fall_gravity


var MAX_SPEED: int = 200
var IS_JUMPING: bool = false
var knockback_vector := Vector2.ZERO
var is_hurted := false
var direction

func _ready():
	jump_velocity = (jump_height * 2) / max_time_to_peek
	gravity = (jump_height * 2) / pow(max_time_to_peek, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	
	if Input.is_key_pressed(KEY_L):
		var mouseToObj = rigid_body_2d.get_local_mouse_position()
		var mouseToPlayer = get_local_mouse_position()
		print("mouse to player", mouseToPlayer)
		print("mouse to obj", mouseToObj.y)
		rigid_body_2d.apply_central_impulse(Vector2(mouseToObj.x, 0))
	
	# Add the gravity.
	if not is_on_floor():
		#velocity.y += gravity * delta
		velocity.x = 0
	
	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
		

	if IS_JUMPING:
		animation.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity
		IS_JUMPING = true
		jump_fx.play()
	elif is_on_floor():
		IS_JUMPING = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		animation.scale.x = direction

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#animation.play("idle")
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	if Input.is_action_pressed("correr") and Input.get_axis("ui_left", "ui_right") != 0:
		SPEED = move_toward(SPEED, MAX_SPEED, int(SPEED * delta))
		animation.speed_scale = 2
	else:
		SPEED = 100
		animation.speed_scale = 1
	_set_state()
	move_and_slide()
	
	if(position.y > 300):
		Globals.respawn_player()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
			

func _on_hurtbox_body_entered(body):
	if body.is_in_group("enemies"):
		print("Inimigo")
		if ray_right.is_colliding():
			take_damage(Vector2(-200, -200))
		if ray_left.is_colliding():
			take_damage(Vector2(200, -200))
	if body.is_in_group("fireball"):
		if ray_right.is_colliding():
			take_damage(Vector2(-200, -200))
		if ray_left.is_colliding():
			take_damage(Vector2(200, -200))
		body.queue_free()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	print("Globals LIFE", Globals.player_life)
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		print("PLAYER MORREU TAKE_DAMAGE")
		world_01.reload_game()
		queue_free()
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween = get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
	is_hurted = true
	timer.start(.3)

func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	if is_hurted:
		state = "hurt"
	if animation.name != state:
		animation.play(state)

func _on_timer_timeout():
	is_hurted = false;

func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 1:			
			body.break_sprite()
		else:
			body.create_coin()
			body.animation_player.play("hit")


