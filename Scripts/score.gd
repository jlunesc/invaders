extends Label

func _process(_delta):
	text = 'Score: ' + String(get_tree().get_current_scene().score)
