extends CharacterBody2D

const box_pieces = preload("res://prefabs/box_pieces.tscn")

@onready var animation_player := $anim as AnimationPlayer
@export var pieces: PackedStringArray
@export var hitpoints := 3
var impulse := 200

func break_sprite():
	for piece in pieces.size():
		var pieces_instance = box_pieces.instantiate()
		get_parent().add_child(pieces_instance)
		pieces_instance.get_node("texture").texture = load(pieces[piece])
		pieces_instance.global_position = global_position
		pieces_instance.apply_impulse(Vector2(randi_range(impulse, -impulse), randi_range(-impulse, -impulse * 2)))
	queue_free()
