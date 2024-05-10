extends Node2D

@onready var control = $HUD/control
@onready var player_scene = preload("res://actors/character.tscn")
@onready var player := $Character as CharacterBody2D
@onready var camera := $Camera2D as Camera2D
@onready var initial_respawn = $initial_respawn

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.last_scene_name = get_tree().current_scene.name
	Globals.player = player
	Globals.initial_respawn = initial_respawn
	Globals.player.follow_camera(camera)
	control.time_is_up.connect(game_over)
	
func reload_game():
	print("PLAYER MORREU RELOAD_GAME")
	await get_tree().create_timer(1.0).timeout
	var player = player_scene.instantiate()
	add_child(player)
	Globals.player = player
	Globals.player.follow_camera(camera)
	control.reset_clock_timer()
	Globals.coins = 0;
	Globals.score = 0;
	Globals.player_life = 3;
	Globals.respawn_player()

func game_over():
	print("GAME OVER")
	get_tree().change_scene_to_file("res://prefabs/game_over.tscn")
