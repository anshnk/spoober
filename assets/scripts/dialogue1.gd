extends Panel

var dialogues = [
	"Commander Moober: Spoober, do you copy? The Splunkers have taken over the Planet Spoob. If they finish their broadcast, every cat on the planet will fall under their control. We need you to shut them down—fast.",
	"Spoober: Understood. What's the opposition?",
	"Commander Moober: Bad. Splunkers have reinforced the station with auto-guns and drones. Expect resistance. Oh, and Spoober…",
	"Spoober: Yeah?",
	"Commander Moober: Don’t let the noise get to you. If you start hearing… things, stay focused.",
	"Spoober: I’ll handle it. Time to declaw these freaks."
]
var current_index = 0

var typing_speed = 0.005
var wait_after_text = 5.0

var is_typing = false
var can_skip = true

@onready var dialogue_label = $Label
@onready var skip_button = $Button

func _ready():
	skip_button.connect("pressed", Callable(self, "_on_skip_pressed"))
	start_dialogue()

func start_dialogue():
	if current_index >= dialogues.size():
		get_tree().change_scene_to_file("res://game1.tscn")
		return
	dialogue_label.text = ""
	type_text(dialogues[current_index])

func type_text(text: String) -> void:
	if is_typing:
		return
	is_typing = true
	var char_index = 0
	while char_index < text.length():
		dialogue_label.text += text[char_index]
		char_index += 1
		await get_tree().create_timer(typing_speed).timeout
		if not is_typing:
			break
	if not is_typing:
		dialogue_label.text = text
	is_typing = false
	await get_tree().create_timer(wait_after_text).timeout
	current_index += 1
	start_dialogue()

func _on_skip_pressed():
	if is_typing and can_skip:
		is_typing = false
		dialogue_label.text = dialogues[current_index]
		can_skip = false
		await get_tree().create_timer(typing_speed).timeout
		can_skip = true
	else:
		current_index += 1
		start_dialogue()
