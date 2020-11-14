extends Label

func _process(_delta):
	var health = get_tree().get_current_scene().get_node('Player').health
	var max_health = get_tree().get_current_scene().get_node('Player').health_max
	var percentage = stepify(100*health / max_health,1)
	
	if percentage > 100:
		modulate = Color('0ebc15')
	else: 
		if percentage > 40:
			modulate = Color('ffffff')
		elif percentage <= 40: 
			modulate = Color('db1b1b')

	
	text = 'Health: ' + String(percentage)+'%'
