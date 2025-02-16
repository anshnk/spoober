extends Node2D
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
