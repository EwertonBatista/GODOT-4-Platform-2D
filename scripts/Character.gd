extends CharacterBody2D


@export var SPEED: int = 100
@export var JUMP_FORCE: float = -300.0
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var ray_right := $ray_right as RayCast2D
@onready var ray_left := $ray_left as RayCast2D
@onready var timer := $Timer as Timer

var MAX_SPEED: int = 200
var IS_JUMPING: bool = false
var gravity = 1000
var knockback_vector := Vector2.ZERO
var is_hurted := false
var direction

signal player_has_died()

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
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#animation.play("idle")
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	if Input.is_action_pressed("correr"):
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

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
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






