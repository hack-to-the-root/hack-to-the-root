extends Node

const BASE_REWARD = 2.0
const DIFFICULTY_MULTIPLIER = 0.5

onready var prompt_label = get_node("RootContainer/HBoxContainer/ControlsContainer/PromptLabel")
onready var progress_label = get_node("RootContainer/HBoxContainer/ControlsContainer/ProgressLabel")
onready var code_label = get_node("RootContainer/HBoxContainer/ControlsContainer/CodeLabel")

var time_elapsed = 0
var required_characters
var keys_pressed = 0
var timeout
var dummy_source
var finished = false


# Called when the node enters the scene tree for the first time.
func _ready():
	timeout = Globals.task['timeout']
	required_characters = Globals.task['required_characters']
	dummy_source = load_dummy_source("res://scenes/hacking/scriptkiddie/dummy_source.rs.tres")
	
	prompt_label.text = "Start hacking!"
	progress_label.text = "0%"
	code_label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if finished:
		return
	
	update_dummy_code()
	update_progress()
	
	time_elapsed += delta
	
	if time_elapsed > timeout:
		finished = true
		onFailure()
		
	if keys_pressed >= required_characters:
		finished = true
		onSuccess()
	
	
func _input(event):
	if (event is InputEventKey):
		keys_pressed += 1
	
	
func load_dummy_source(path):
	var file = File.new()
	file.open(path, File.READ)
	return file.get_as_text()

func update_progress():
	var percent = (float(keys_pressed) / float(required_characters)) * 100.0
	
	if percent > 100:
		percent = 100
		
	progress_label.text = str(int(percent)) + "%"
	
	
func update_dummy_code():
	var characters = keys_pressed * 8
	var current_dummy_code = dummy_source.substr(0, characters)
	
	code_label.text = current_dummy_code
	
	
func onSuccess():
	prompt_label.text = "Success!"
	Globals.addMoney(int(BASE_REWARD * DIFFICULTY_MULTIPLIER * Globals.task['difficulty']))
	Globals.setTaskOutcome(true)
	returnToOverworld()
	

func onFailure():
	prompt_label.text = "You were not fast enough"
	Globals.setTaskOutcome(false)
	returnToOverworld()
	

	
func returnToOverworld():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://scenes/overworld/overworld.tscn")
	
	
