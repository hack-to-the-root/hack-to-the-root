extends Button


func _on_ServerButton_pressed():
	Globals.setScriptKiddieTask()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/hacking/scriptkiddie/scriptkiddie.tscn")

