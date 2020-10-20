extends KinematicBody2D

export var velocity = 0
export var turning = 1.0

func _ready():
	add_to_group('Blocks')
	$CollisionShape2D.position = Vector2(100, 0)

func _process(delta):
	if Input.is_action_pressed("block_turn_left"):
		rotation -= turning * delta
	if Input.is_action_pressed("block_turn_right"):
		rotation += turning * delta
	move_and_collide(Vector2.RIGHT.rotated(rotation) * velocity * delta)
	
