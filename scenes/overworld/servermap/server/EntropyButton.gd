extends Button


func _on_EntropyButton_pressed():
	Globals.setRandomnessTask()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/hacking/randomness/randomness.tscn")

