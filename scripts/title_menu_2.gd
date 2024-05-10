extends Control

@onready var animation_player = $AnimationPlayer
@onready var margin_container = $MarginContainer

func _ready():
	Globals.coins = 0;
	Globals.score = 0;
	Globals.player_life = 3;

func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/world_01.tscn")

func _on_credits_btn_pressed():
	pass

func _on_quit_btn_pressed():
	get_tree().quit()
	
func _unhandled_input(event):
	if event.is_action_pressed("TEST"):
		animation_player.play("intro")
