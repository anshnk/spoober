extends Node2D

var spawn_interval = 1.0
var time_passed = 0.0
@onready var menu = $CanvasLayer/Control
@onready var death_screen = $CanvasLayer/DeathScreen
@onready var retry_button = $CanvasLayer/DeathScreen/Panel/RetryButton
@onready var time_label = $CanvasLayer/Time
@onready var kills_label = $CanvasLayer/SplunkersKilled
@onready var splunker_script = preload("res://assets/scripts/splunkers.gd")

var time_alive = 0.0
var splunkers_killed = 0
@export var kill_goal = 10

func _ready():
	add_to_group("game_manager")
	randomize()
	menu.process_mode = Node.PROCESS_MODE_ALWAYS
	death_screen.process_mode = Node.PROCESS_MODE_ALWAYS

	for button in menu.get_children():
		if button is Control:
			button.process_mode = Node.PROCESS_MODE_ALWAYS

	death_screen.visible = false 

	if retry_button:
		retry_button.process_mode = Node.PROCESS_MODE_ALWAYS
		retry_button.connect("pressed", Callable(self, "_on_retry_pressed"))
	else:
		print("Retry button not found.")

func _process(delta: float) -> void:
	time_alive += delta
	time_label.text = "Time: " + str(round(time_alive * 100) / 100)

	time_passed += delta
	if time_passed >= spawn_interval:
		time_passed = 0.0
		_spawn_circle()
		spawn_interval = randf_range(0.5, 3.0)

func _spawn_circle() -> void:
	print("Spawning a new splunker.")
	var splunker = Sprite2D.new()
	splunker.texture = preload("res://assets/images/Splunker.png")
	splunker.set_script(splunker_script)
	if splunker:
		add_child(splunker)
		var position_valid = false
		while not position_valid:
			splunker.position = Vector2(
				randf_range(0, get_viewport_rect().size.x),
				randf_range(0, get_viewport_rect().size.y)
			)
			position_valid = true
			for other in get_tree().get_nodes_in_group("enemies"):
				if other != splunker and splunker.position.distance_to(other.position) < 50:
					position_valid = false
					break
		print("Splunker spawned at position: ", splunker.position)
	else:
		print("Failed to load splunker script.")

func player_died():
	print("Player died!")
	death_screen.visible = true
	get_tree().paused = true

func increment_kills():
	splunkers_killed += 1
	kills_label.text = "Splunkers Killed: " + str(splunkers_killed) + "/10"
	check_for_victory()

func _change_scene_to_victory():
	get_tree().change_scene_to_file("res://dialogue2.tscn")

func check_for_victory():
	if splunkers_killed >= kill_goal:
		print("Victory! Switching scene...")
		call_deferred("_change_scene_to_victory")

func _on_retry_pressed():
	print("Retry button pressed!")
	get_tree().paused = false
	death_screen.visible = false
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_cancel"): 
		toggle_menu()

func toggle_menu():
	menu.visible = !menu.visible

	for button in menu.get_children():
		if button is Control:
			button.process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().paused = menu.visible

func _on_ResumeButton_pressed():
	print("Resume button pressed")
	toggle_menu()

func _on_QuitButton_pressed():
	print("Quit button pressed! Changing to Main Menu...")
	toggle_menu()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func die():
	var game_node = get_tree().get_root().get_node("Game1")
	if game_node:
		game_node.increment_kills()
	queue_free()
