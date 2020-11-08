extends Area2D

var speed = 300

func _ready():
	add_to_group('bullets_invader')

func _physics_process(delta):	
	position += - transform.y * speed * delta

func _on_BulletInvader_body_entered(body):
	if body.name == 'Player':
		body._get_damage()
		_disapear()
	elif body.is_in_group("DestructibleBlock"):
		body.queue_free()
		_disapear()

func _on_BulletInvader_area_entered(area):
	if area.is_in_group("bullets_player"):
		area.queue_free()
		_disapear()

func _disapear():
	get_tree().get_current_scene().get_node('SoundFxs/impact_others').play()
	queue_free()
