extends Button

func _ready() -> void:
	connect("pressed", Callable(self, "_on_Button_pressed"))

func _process(_delta: float) -> void:
	pass

func _on_Button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
