extends Node2D

export (PackedScene) var Bullet

export var velocity = 0
export var rotation_speed = 1
export var moving_rate = 2.0
var _timer

func _ready():
	add_to_group('Invaders')
	_timer = Timer.new()
	add_child(_timer)
	_timer.start(moving_rate)
	_timer.autostart = true

func _process(delta):
	_move(delta)
	_can_shoot()

func _move(delta):
	if _timer.get_time_left() < 1:
		_timer.stop()
		_timer.start(moving_rate)
		$Area2D.rotation += rotation_speed * delta
	else:
		$Area2D.rotation += 0
		
func _shoot():
	var b = Bullet.instance()
	owner.add_child(b)
	b.transform = $Area2D/CollisionShape2D/Sprite/Position2D.global_transform
	
func _can_shoot():
	var collider = get_node('Area2D/CollisionShape2D/Sprite/Position2D/RayCast2D').get_collider()
	if  not is_instance_valid(collider):
		get_node('Area2D/CollisionShape2D/Sprite').modulate = Color(250,0,0)
		return true
		
	elif is_instance_valid(collider):
		if not collider.get_parent().is_in_group("Invaders"):
			get_node('Area2D/CollisionShape2D/Sprite').modulate = Color(250,0,0)
			return true
		else:
			get_node('Area2D/CollisionShape2D/Sprite').modulate = Color(0,0,250)
			return false
	else:
		get_node('Area2D/CollisionShape2D/Sprite').modulate = Color(0,0,250)
		return false
