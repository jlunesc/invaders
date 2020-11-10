extends Area2D

var speed = 500

func _ready():
	add_to_group('bullets_player')
	$CollisionShape2D.scale = Vector2(0.5,0.5)

func _physics_process(delta):
	position += - transform.y * speed * delta

func _on_Bullet_area_entered(area):
	if area.get_parent().is_in_group("Invaders"):
		area.get_parent().queue_free()
		_increase_score()
	elif area.is_in_group("bullets_invader"):
		area.queue_free()
		_increase_score()
	_disapear()

func _on_Bullet_body_entered(body):
	if body.is_in_group("DestructibleBlock"):
		body.queue_free()
		_disapear()

func _disapear():
	get_tree().get_current_scene()._make_explosion(position)
	get_tree().get_current_scene().get_node('SoundFxs/impact_others').play() 
	queue_free()

func _increase_score():
	get_tree().get_current_scene().score += 1
