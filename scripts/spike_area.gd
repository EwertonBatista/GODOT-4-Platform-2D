extends Area2D

@onready var texture = $texture as Sprite2D
@onready var collision = $collision as CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape.size = texture.get_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Character" && body.has_method("take_damage"):
		body.take_damage(Vector2(0,-250))
		
		
