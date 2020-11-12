extends Label

func _process(_delta):
	text = 'GAME OVER \nYou scored ' + String(get_tree().get_current_scene().score) + '\nR to retry'
