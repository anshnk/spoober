extends Sprite2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	rotation += _delta * 2.0
