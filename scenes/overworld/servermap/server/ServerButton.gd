extends Button

func _on_ServerButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/hacking/qa.tscn")

