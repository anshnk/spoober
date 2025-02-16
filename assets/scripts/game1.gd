extends Node2D

var spawn_interval = 2.0
var time_passed = 0.0

func _ready() -> void:
    randomize()
    print("Game started, ready to spawn circles.")

func _process(delta: float) -> void:
    time_passed += delta
    if time_passed >= spawn_interval:
        time_passed = 0.0
        _spawn_circle()
        spawn_interval = randf_range(0.5, 3.0)

func _spawn_circle() -> void:
    print("Spawning a new circle.")
    var circle = Sprite2D.new()
    circle.texture = preload("res://assets/images/splunker.png")
    circle.set_script(load("res://assets/scripts/splunkers.gd"))
    if circle:
        add_child(circle)
        var position_valid = false
        while not position_valid:
            circle.position = Vector2(
                randf_range(0, get_viewport_rect().size.x),
                randf_range(0, get_viewport_rect().size.y)
            )
            position_valid = true
            for other in get_tree().get_nodes_in_group("enemies"):
                if other != circle and circle.position.distance_to(other.position) < 50:
                    position_valid = false
                    break
        print("Circle spawned at position: ", circle.position)
    else:
        print("Failed to load splunkers.gd")