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
		_increase_score(1)
		get_tree().get_current_scene()._n_invaders_killed += 1
	elif area.is_in_group("bullets_invader"):
		area.queue_free()
		_increase_score(0.5)
		var current_health = get_tree().get_current_scene().get_node('Player').health
		get_tree().get_current_scene().get_node('Player').health += 0.33*current_health
		get_tree().get_current_scene().get_node('Player').health_max += 0.15

	elif area.get_parent().is_in_group("big_bosses"):
		area.get_parent()._get_damage(1.0)
		_increase_score(2)
	elif area.get_parent().is_in_group("final_boss"):
		area.get_parent()._get_damage(1.0)
		_increase_score(10)
	_disapear()

func _on_Bullet_body_entered(body):
	if body.is_in_group("DestructibleBlock"):
		body.queue_free()
		_disapear()

func _disapear():
	get_tree().get_current_scene()._make_explosion(position)
	get_tree().get_current_scene().get_node('SoundFxs/impact_others').play() 
	queue_free()

func _increase_score(_added):
	get_tree().get_current_scene().score += _added
