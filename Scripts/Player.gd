extends KinematicBody2D

export (PackedScene) var Bullet

export var velocity = 0
export var turning = 2.0

func _process(delta):
	if Input.is_action_pressed("turn_left"):
		rotation -= turning * delta
	if Input.is_action_pressed("turn_right"):
		rotation += turning * delta
	if Input.is_action_just_pressed("shoot"):
		shoot()
	move_and_collide(Vector2.RIGHT.rotated(rotation) * velocity * delta)

func shoot():
	$Camera2D.shake(0.25, 50, 2)
	var b = Bullet.instance()
	owner.add_child(b)
	b.transform = $Position2D.global_transform

func _get_damage():
	$Camera2D.shake(0.75, 150, 7.5)
