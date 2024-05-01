extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var area_2d = $Area2D

const lines: Array[String] = [
	"Olá, aventureiro!",
	"É muito bom ver você aqui",
	"Espero que esteja preparado...",
	"Sua jornada está apenas...",
	"...COMEÇANDO"
]

func _unhandled_input(event):
	if area_2d.get_overlapping_bodies().size() > 0:
		sprite_2d.show()
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			sprite_2d.hide()
			DialogManager.start_message(global_position, lines)
	else:
		sprite_2d.hide()
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
