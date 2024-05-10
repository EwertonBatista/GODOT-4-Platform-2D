extends Area2D

@onready var anim = $anim as AnimatedSprite2D
@onready var coin_sfx = $coin_sfx as AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	anim.play("collected")
	coin_sfx.play()
	await $collision.call_deferred("queue_free")
	Globals.coins += 1
	
	

func _on_anim_animation_finished():
	if anim.animation == "collected":
		queue_free()

