extends Button


func _on_QuestionButton_pressed():
	Globals.setQuestionTask()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/hacking/qa.tscn")
