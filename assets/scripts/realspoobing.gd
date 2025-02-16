extends Sprite2D

var speed = 500
var velocity = Vector2.ZERO
var friction = 0.99
@export var max_health: int = 100
var health: int = max_health

@onready var health_bar = $HealthBar
@onready var collision_area = $CollisionArea

func _ready():
	add_to_group("player")
	update_health_bar()
	collision_area.connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float):
	var input_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1
	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()

	var desired_velocity = input_direction * speed
	velocity = velocity.move_toward(desired_velocity, speed * 4 * delta)
	velocity *= friction
	position += velocity * delta

	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	var mouse_pos = get_global_mouse_position()
	rotation = (mouse_pos - global_position).angle()

	if Input.is_action_just_pressed("shoot"):
		_shoot_bullet(mouse_pos)

func _shoot_bullet(target_position: Vector2):
	var bullet = load("res://assets/scripts/Bullet.gd").new()
	bullet.position = global_position
	bullet.direction = (target_position - global_position).normalized()
	get_parent().add_child(bullet)

func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	update_health_bar()
	if health <= 0:
		die()

func heal(amount: int):
	health += amount
	health = min(health, max_health)
	update_health_bar()

func update_health_bar():
	if health_bar:
		health_bar.value = health

func die():
	var game1 = get_node("/root/Game1")
	if game1:
		game1.player_died()
	hide()

func _on_body_entered(body):
	if body.is_in_group("bullets"):
		take_damage(5)
	elif body.is_in_group("enemies"):
		take_damage(10)
