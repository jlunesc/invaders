extends Label

func _process(delta):
	text = 'Score: ' + String(get_tree().get_current_scene().score)
