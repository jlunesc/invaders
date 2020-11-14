extends Label

func _ready():
	add_to_group('labels')

func _process(_delta):
	var health = get_tree().get_current_scene().get_node('InvaderContainer').get_child(0).health
	var max_health = get_tree().get_current_scene().get_node('InvaderContainer').get_child(0).max_health
	var percentage = stepify(100*health / max_health,1)
	
	modulate = Color('db1b1b')
	text = String(percentage)+'%'
