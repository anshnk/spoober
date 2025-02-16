extends Area2D

var speed = 800
var direction = Vector2.ZERO

func _ready() -> void:
	set_process(true)
	add_to_group("bullets")
	collision_layer = 1
	collision_mask = 2
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/images/spoober.png")
	sprite.scale = Vector2(0.03, 0.03)
	add_child(sprite)
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 64
	collision_shape.shape = shape
	add_child(collision_shape)

func _process(delta: float) -> void:
	position += direction * speed * delta
	var screen_size = get_viewport_rect().size
	if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()
		queue_free()
