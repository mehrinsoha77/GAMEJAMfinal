extends Control
## Level 1's BRS trivia challenge. Any puzzle plugged into a Terminal
## only has to satisfy one contract: emit "puzzle_solved" when done.

signal puzzle_solved

@export var question: String = "What is the full form of BRS?"
@export var correct_answer: String = "BUET Robotics Society"
@export var wrong_answers: Array[String] = [
	"Bangladesh Robotics Society",
	"BUET Research Systems",
	"Basic Robotics Software",
]

@onready var question_label: Label = $Panel/VBox/Question
@onready var answers_box: VBoxContainer = $Panel/VBox/Answers

func _ready() -> void:
	question_label.text = question
	var options := wrong_answers.duplicate()
	options.append(correct_answer)
	options.shuffle()
	for option: String in options:
		var btn := Button.new()
		btn.text = option
		btn.pressed.connect(_on_answer_pressed.bind(option))
		answers_box.add_child(btn)

func _on_answer_pressed(chosen: String) -> void:
	for child in answers_box.get_children():
		child.disabled = true
	if chosen == correct_answer:
		puzzle_solved.emit()
	else:
		AudioManager.play_sfx("puzzle_wrong")
		for child in answers_box.get_children():
			child.disabled = false
