extends Label

func _process(_delta):
	if get_tree().get_current_scene().get_node('Player').amo > 0:
		modulate = Color('ffffff')
	else: 
		modulate = Color('db1b1b')
	var _amo = get_tree().get_current_scene().get_node('Player').amo
	var _max_amo = get_tree().get_current_scene().get_node('Player').amo_max
	text = 'amo: ' + String(_amo) + '/' + String(_max_amo)
