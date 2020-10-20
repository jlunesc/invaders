extends Area2D

var speed = 250

func _ready():
	add_to_group('bullets_invader')
	# $CollisionShape2D.scale = Vector2(0.5,0.5)

func _physics_process(delta):	
	position += - transform.x * speed * delta

func _on_BulletInvader_body_entered(body):
	if body.name == 'Player':
		get_tree().reload_current_scene()
		queue_free()
	elif body.is_in_group("Blocks"):
		queue_free()

func _on_BulletInvader_area_entered(area):
	if area.is_in_group("bullets_player"):
		area.queue_free()
		queue_free()
