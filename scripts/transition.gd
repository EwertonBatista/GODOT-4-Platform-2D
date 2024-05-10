extends CanvasLayer

@onready var color_rect = $color_rect

func _ready():
	print("ADASDASd")
	show_scene()

func change_scene(path, delay = 2.5):
	var scene_trasition = get_tree().create_tween()
	scene_trasition.tween_property(color_rect, "threshold", 1.0, .5).set_delay(delay)
	await scene_trasition.finished
	assert(get_tree().change_scene_to_file(path) == OK)

func show_scene():
	var show_trasition = get_tree().create_tween()
	show_trasition.tween_property(color_rect, "threshold", 0, 0.5).from(1.0)
