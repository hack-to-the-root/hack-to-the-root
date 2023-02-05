extends Button


func _on_QuestionButton_pressed():
	Globals.setCurrentButton(str(get_path()))
	Globals.setQuestionTask()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/hacking/question/question.tscn")

