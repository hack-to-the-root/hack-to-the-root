extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var question
var answer

# Called when the node enters the scene tree for the first time.
func _ready():
	question = get_node("question")
	answer = get_node("answer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if answer.text == "42":
		question.text = "Got it!"
