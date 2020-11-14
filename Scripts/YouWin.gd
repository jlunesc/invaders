extends Label

func _process(_delta):
	text = 'You WIN!!! \nYou scored ' + String(get_tree().get_current_scene().score) + '\nYou want a medal?'
	modulate = Color('ffffff')
