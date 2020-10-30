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
