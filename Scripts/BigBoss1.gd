extends Node2D

export (PackedScene) var Bullet

export var velocity = 0
export var rotation_speed = 0.65

var _timer_movement
var moving_time = 5
var health = 2

var _keep_shooting = true

var rng = RandomNumberGenerator.new()

func _ready():
	add_to_group('big_bosses')
	rng.randomize()
	_timer_movement = Timer.new()
	add_child(_timer_movement)
	_timer_movement.start(rng.randfn(moving_time,1.15))
	_timer_movement.autostart = true

func _process(delta):
	_move(delta)
	_can_shoot()

func _move(delta):
	if _timer_movement.get_time_left() > 1:
		_keep_shooting = true
		$Area2D.rotation += rotation_speed * delta * (-1.0)
	elif _timer_movement.get_time_left() < 1:
		if _keep_shooting:
			if _can_shoot():
				_shoot()
				_keep_shooting = false

func _can_shoot():
	var collider = get_node('Area2D/CollisionShape2D/RayCast2D').get_collider()
	if  not is_instance_valid(collider):
		get_node('Area2D/CollisionShape2D/Sprite').modulate = Color('ffffff')
		return true
		
	elif is_instance_valid(collider):
		if not collider.get_parent().is_in_group("Invaders"):
			get_node('Area2D/CollisionShape2D/Sprite').modulate = Color('ffffff')
			return true
		else:
			get_node('Area2D/CollisionShape2D/Sprite').modulate = Color('00edff')
			return false
	else:
		get_node('Area2D/CollisionShape2D/Sprite').modulate = Color('00edff')
		return false

func _shoot():
	get_tree().get_current_scene().get_node('SoundFxs/shoot_invader').play()
	var b = Bullet.instance()
	b.damage_bullet = 1.0
	b.modulate = Color('710957')
	add_child(b)
	b.transform = $Area2D/CollisionShape2D/Position2D.global_transform

func _get_damage(damage_received):
	rotation_speed += 0.20
	modulate = Color('ff0e02')
	health -= damage_received
	if health <= 0:
		queue_free()
