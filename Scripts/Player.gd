extends KinematicBody2D

export (PackedScene) var Bullet

export var velocity = 0
export var turning = 4.0

func _process(delta):
	if Input.is_action_pressed("turn_left"):
		rotation -= turning * delta
	if Input.is_action_pressed("turn_right"):
		rotation += turning * delta
	if Input.is_action_just_pressed("shoot"):
		shoot()
	move_and_collide(Vector2.RIGHT.rotated(rotation) * velocity * delta)

func shoot():
	var b = Bullet.instance()
	owner.add_child(b)
	b.transform = $Position2D.global_transform
