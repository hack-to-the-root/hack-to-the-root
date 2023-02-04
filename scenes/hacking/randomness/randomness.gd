extends Node

const FINGERPRINT = """
+--[ED25519 256]--+
|      ..o        |
|     . +         |
|      O          |
|     + =         |
|   .o.. S        |
|   .+=.  +   .   |
|   ..+= . + oE .o|
| .o .o+= oo+  =o.|
| o=+.=Bo== .+= ..|
+----[SHA256]-----+
"""

onready var prompt_label = get_node("RootContainer/HBoxContainer/ControlsContainer/PromptLabel")
onready var progress_label = get_node("RootContainer/HBoxContainer/ControlsContainer/ProgressLabel")
onready var fingerprint_label = get_node("RootContainer/HBoxContainer/ControlsContainer/FingerprintLabel")

var time_elapsed = 0
var required_randomness
var randomness_generated = 0
var progress = 0
var timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout = 10#Globals.task['timeout']
	required_randomness = 500#Globals.task['required_randomness']
	
	prompt_label.text = "Generate randomness!"
	progress_label.text = "0%"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_fingerprint()
	update_progress()
	
	time_elapsed += delta
	
	if time_elapsed > timeout:
		onFailure()
		
	if randomness_generated >= required_randomness:
		onSuccess()
	
	
func _input(event):
	if (event is InputEventMouse):
		randomness_generated += 1
	

func update_progress():
	progress = (float(randomness_generated) / float(required_randomness)) * 100.0
	
	if progress > 100:
		progress = 100
		
	progress_label.text = str(int(progress)) + "%"
	

func update_fingerprint():
	var chars = (float(FINGERPRINT.length()) / 100.0) * progress
	var fingerprint = FINGERPRINT.substr(0, chars)
	
	if progress == 100:
		fingerprint = FINGERPRINT
		
	fingerprint_label.text = fingerprint 
	
	
func onSuccess():
	prompt_label.text = "Success!"
	returnToOverworld()
	

func onFailure():
	prompt_label.text = "You didn't generate enough randomness"
	returnToOverworld()
	
	
func returnToOverworld():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://scenes/overworld/overworld.tscn")
	
	
