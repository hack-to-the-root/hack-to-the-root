extends Node2D

onready var questionLabel = get_node("RootContainer/HBoxContainer/VBoxContainer/QuestionLabel")
onready var regexLabel = get_node("RootContainer/HBoxContainer/VBoxContainer/RegexLabel")
onready var answerInput = get_node("RootContainer/HBoxContainer/VBoxContainer/AnswerInput")

var task
var regex

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
	var file = File.new()
	file.open("res://scenes/hacking/config.yaml", File.READ)
	var config = file.get_as_text()
	file.close()
	config = yaml.parse(config).result
	var index = randi() % config.size()
	
	task = config[index]
	
	match task['type']:
		'scriptkiddie':
			questionLabel.text = 'HURRY UP! H4CK 7H3 5Y57T3M'
		'question':
			questionLabel.text = task['prompt']
		'regex':
			regexLabel.text = task['regex']
			regex = RegEx.new()
			regex.compile("^" + task['regex'] + "$")
			questionLabel.text = task['prompt']
			

func onSuccess():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://scenes/overworld/overworld.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match task['type']:
		'scriptkiddie':
			if(answerInput.text.length() >= task['required_characters']):
				questionLabel.text = 'You are a super hacker!'
				onSuccess()
		'question':
			if(answerInput.text.length() >= task['answer']):
				questionLabel.text = 'Correct!'
				onSuccess()
		'regex':
			if(regex.search(answerInput.text) != null):
				questionLabel.text = 'Regex matches!'
				onSuccess()
