extends KinematicBody2D

export (PackedScene) var Bullet

export var velocity = 0
export var turning = 4
export var moving_rate = 2.0
var _timer

func _ready():
	add_to_group('Invaders')
	$CollisionShape2D.position = Vector2(300, 0)
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
		rotation -= turning * delta
		move_and_collide(Vector2.RIGHT.rotated(rotation) * 0 * delta)
		get_node('CollisionShape2D').position -= Vector2(2, 0)
	else:
		rotation -= 0
		move_and_collide(Vector2.RIGHT.rotated(rotation) * 0 * delta)

func _shoot():
	var b = Bullet.instance()
	owner.add_child(b)
	b.transform = $CollisionShape2D/Sprite/Position2D.global_transform
