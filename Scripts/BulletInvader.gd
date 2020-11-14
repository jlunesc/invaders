extends Area2D

var speed = 300
var damage_bullet = 0.33

func _ready():
	add_to_group('bullets_invader')

func _physics_process(delta):
	position += - transform.y * speed * delta

func _on_BulletInvader_body_entered(body):
	if body.name == 'Player':
		body._get_damage(damage_bullet)
		_disapear()
	elif body.is_in_group("DestructibleBlock"):
		body.queue_free()
		_disapear()

func _disapear():
	get_tree().get_current_scene()._make_explosion(position)
	get_tree().get_current_scene().get_node('SoundFxs/impact_others').play()
	queue_free()
