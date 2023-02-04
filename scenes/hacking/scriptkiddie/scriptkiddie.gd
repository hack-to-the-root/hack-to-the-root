extends Node

onready var prompt_label = get_node("RootContainer/HBoxContainer/ControlsContainer/PromptLabel")
onready var progress_label = get_node("RootContainer/HBoxContainer/ControlsContainer/ProgressLabel")
# TODO: code node

var time_elapsed = 0
var required_characters
var keys_pressed = 0
var timeout


# Called when the node enters the scene tree for the first time.
func _ready():
	timeout = Globals.task['timeout']
	required_characters = Globals.task['required_characters']
	
	prompt_label.text = "Start hacking!"
	progress_label.text = "0%"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_progress()
	time_elapsed += delta
	
	if time_elapsed > timeout:
		onFailure()
		
	if keys_pressed >= required_characters:
		onSuccess()
	
	
func _input(event):
	if (event is InputEventKey):
		keys_pressed += 1
	
	
func update_progress():
	var percent = (float(keys_pressed) / float(required_characters)) * 100.0
	
	if percent <= 100:
		progress_label.text = str(int(percent)) + "%"
	
	
func onSuccess():
	prompt_label.text = "Success!"
	returnToOverworld()
	

func onFailure():
	prompt_label.text = "You were not fast enough"
	returnToOverworld()
	

	
func returnToOverworld():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://scenes/overworld/overworld.tscn")
	
	
