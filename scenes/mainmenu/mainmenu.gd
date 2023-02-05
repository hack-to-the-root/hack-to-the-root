extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/overworld/overworld.tscn")



func _on_HelpButton_pressed():
	pass # Replace with function body.


func _on_CreditsButton_pressed():
	OS.shell_open("https://github.com/hack-to-the-root/hack-to-the-root#credits")


func _on_ExitButton_pressed():
	get_tree().quit(0);
