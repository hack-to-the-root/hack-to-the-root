extends Button


func _on_RegexButton_pressed():
	Globals.setCurrentButton(str(get_path()))
	Globals.setRegexTask()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/hacking/regex/regex.tscn")

