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
	
	var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
	var file = File.new()
	file.open("res://scenes/hacking/config.yaml", File.READ)
	var config = file.get_as_text()
	file.close()
	config = yaml.parse(config).result
	for line in config:
		for question in line:
			print(question)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if answer.text == "42":
		question.text = "Got it!"
