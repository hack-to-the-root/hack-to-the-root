extends Node2D

const BASE_REWARD = 20.0
const DIFFICULTY_MULTIPLIER = 0.5
	  
onready var question_label = get_node("RootContainer/HBoxContainer/VBoxContainer/VBoxContainer/QuestionLabel")
onready var regex_label = get_node("RootContainer/HBoxContainer/VBoxContainer/VBoxContainer/RegexLabel")
onready var status_label = get_node("RootContainer/HBoxContainer/VBoxContainer/VBoxContainer/StatusLabel")
onready var answer_input = get_node("RootContainer/HBoxContainer/VBoxContainer/VBoxContainer/AnswerInput")
onready var submit_button = get_node("RootContainer/HBoxContainer/VBoxContainer/VBoxContainer/SubmitButton")
onready var skip_button = get_node("RootContainer/HBoxContainer/VBoxContainer/VBoxContainer2/HBoxContainer/SkipButton")

var compiled_regex = RegEx.new()
var attempts = 0
var time_elapsed = 0
var finished = false
var submitted = false
var input_disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	question_label.text = Globals.task['prompt']
	regex_label.text = Globals.task['regex']
	compiled_regex.compile("^" + Globals.task['regex'] + "$")
	submit_button.connect("pressed", self, "_button_pressed")
	answer_input.grab_focus()
	
	if Globals.hasFeature("joker"):
		skip_button.visible = true
		skip_button.connect("pressed", self, "_skip_button_pressed")

func _process(delta):
	if finished:
		return
		
	update_status()
	
	time_elapsed += delta
	
	if time_elapsed > Globals.task['timeout'] && Globals.task['timeout'] != -1:
		finished = true
		status_label.text = "Time elapsed"
		onFailure()
		
	if attempts >= Globals.task['attempts'] && Globals.task['attempts'] != -1:
		finished = true
		status_label.text = "You failed"
		onFailure()
		
	if submitted:
		attempts += 1
		
		if(compiled_regex.search(answer_input.text) != null):
			finished = true
			question_label.text = 'Correct!'
			onSuccess()
		else:
			answer_input.text = ""
			submitted = false
			


func _button_pressed():
	submitted = true;

	
func _skip_button_pressed():
	Globals.useFeature("joker")
	finished = true
	status_label.text = "skipped"
	onSuccess()
	

func _input(event):
	if finished || input_disabled:
		return
		
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ENTER:
			submitted = true


func disable_input():
	input_disabled = true
	answer_input.editable = false
	submit_button.disabled = true
	skip_button.disabled = true
	

func enable_input():
	input_disabled = false
	answer_input.editable = true
	submit_button.disabled = false


func update_status():
	var time_left = Globals.task['timeout'] - time_elapsed
	var attempts_left = Globals.task['attempts'] - attempts
	
	status_label.text = "time left: {time}\nremaining attempts: {attempts}".format({
		"time": str(time_left).pad_decimals(2),
		"attempts": attempts_left if Globals.task['attempts'] != -1 else "infinite"
	})
	

func onSuccess():
	disable_input()
	Globals.setTaskOutcome(true)
	Globals.addMoney(int(BASE_REWARD * DIFFICULTY_MULTIPLIER * Globals.task['difficulty']))
	returnToOverworld()

	
func onFailure():
	disable_input()
	Globals.setTaskOutcome(false)
	returnToOverworld()

				
func returnToOverworld():
	yield(get_tree().create_timer(3.0), "timeout")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/overworld/overworld.tscn")
