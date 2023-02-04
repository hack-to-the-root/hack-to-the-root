extends Button


func _on_EntropyButton_pressed():
	Globals.setCurrentButton(str(get_path()))
	Globals.setRandomnessTask()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/hacking/randomness/randomness.tscn")

