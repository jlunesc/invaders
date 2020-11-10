extends Label

func _process(delta):
	text = 'Health: ' + String(stepify(get_tree().get_current_scene().get_node('Player').health,0.1))
