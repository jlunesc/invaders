extends Label

func _process(delta):
	if get_tree().get_current_scene().get_node('Player').amo > 0:
		modulate = Color('ffffff')
	else: 
		modulate = Color('db1b1b')
		
	text = 'amo: ' + String(stepify(get_tree().get_current_scene().get_node('Player').amo,0.1))
