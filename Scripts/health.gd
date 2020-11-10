extends Label

func _process(_delta):
	var health = get_tree().get_current_scene().get_node('Player').health
	var max_health = get_tree().get_current_scene().get_node('Player').health_max
	var percentage = stepify(100*health / max_health,1)
	
	if percentage > 40:
		modulate = Color('ffffff')
	else: 
		modulate = Color('db1b1b')
	
	text = 'Health: ' + String(percentage)+'%'
