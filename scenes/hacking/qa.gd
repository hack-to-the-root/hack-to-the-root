extends Node2D

onready var questionLabel = get_node("RootContainer/HBoxContainer/VBoxContainer/QuestionLabel")
onready var regexLabel = get_node("RootContainer/HBoxContainer/VBoxContainer/RegexLabel")
onready var answerInput = get_node("RootContainer/HBoxContainer/VBoxContainer/AnswerInput")

var task
var regex

# Called when the node enters the scene tree for the first time.
func _ready():
	task = Globals.task
	match task['type']:
		'question':
			questionLabel.text = task['prompt']
		'regex':
			regexLabel.text = task['regex']
			regex = RegEx.new()
			regex.compile("^" + task['regex'] + "$")
			questionLabel.text = task['prompt']

	answerInput.grab_focus()

func onSuccess():
	get_tree().paused = true
	yield(get_tree().create_timer(3.0), "timeout")

	Globals.addMoney(15 * task['difficulty'])
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/overworld/overworld.tscn")
	
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match task['type']:
		'question':
			if(answerInput.text == str(task['solution'])):
				questionLabel.text = 'Correct!'
				onSuccess()
		'regex':
			if(regex.search(answerInput.text) != null):
				questionLabel.text = 'Regex matches!'
				onSuccess()
