extends Sprite2D

var speed = 150

func _ready() -> void:
	set_process(true)
	add_to_group("enemies")
	scale = Vector2(0.06, 0.06)
	var area = Area2D.new()
	area.position = Vector2.ZERO
	area.collision_layer = 2
	area.collision_mask = 1
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 32
	collision_shape.shape = shape
	collision_shape.position = Vector2.ZERO
	area.add_child(collision_shape)
	add_child(area)
	area.connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta: float) -> void:
	var spoober = get_node_or_null("/root/Game1/Spoober")
	if spoober:
		position = position.move_toward(spoober.global_position, speed * delta)
		rotation = (spoober.global_position - global_position).angle()


func _on_area_entered(area: Area2D):
	if get_tree().paused:
		return
	
	if area.is_in_group("bullets"):
		die()
		queue_free()
		area.queue_free()
	elif area.get_parent().is_in_group("player"):
		area.get_parent().take_damage(5)

func die():
	var game_node = get_tree().get_first_node_in_group("game_manager")
	if game_node:
		game_node.increment_kills()
