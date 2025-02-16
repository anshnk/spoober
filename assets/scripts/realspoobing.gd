extends Sprite2D

var speed = 500
var velocity = Vector2.ZERO
var friction = 0.99

func _ready() -> void:
    pass

func _process(delta: float) -> void:
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
    if velocity.x < 0:
        scale.x = abs(scale.x) * -1
    elif velocity.x > 0:
        scale.x = abs(scale.x)
    position += velocity * delta
    var screen_size = get_viewport_rect().size
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
    var mouse_pos = get_global_mouse_position()
    rotation = (mouse_pos - global_position).angle()
    if Input.is_action_just_pressed("shoot"):
        _shoot_bullet(mouse_pos)

func _shoot_bullet(target_position: Vector2) -> void:
    var bullet = load("res://assets/scripts/Bullet.gd").new()
    bullet.position = global_position
    bullet.direction = (target_position - global_position).normalized()
    get_parent().add_child(bullet)
