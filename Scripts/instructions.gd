extends Label

func _process(_delta):
	text = 'WASD to move\nSpace to shoot'
	# text = 'GAME OVER \nYour score: ' + String(get_tree().get_current_scene().score)
