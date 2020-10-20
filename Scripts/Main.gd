extends Node2D

var Invader = preload("res://Scenes/Invaders.tscn")
var Block = preload("res://Scenes/Blocks.tscn")
var _timer
var rng = RandomNumberGenerator.new()

func _ready():
	# timer for the first shoot
	_timer = Timer.new()
	add_child(_timer)
	_timer.start()
	_timer.autostart = true
	_add_invaders() 	# placement of the invaders
	_add_blokcs()

func _process(delta):
	if _timer.get_time_left() < 1:
		_invader_shoot()

func _invader_shoot():
	rng.randomize()
	_timer.stop()
	var invader_index = rng.randf_range(0, 
					get_node("InvaderContainer").get_child_count() - 1)
	if not is_instance_valid(get_node("InvaderContainer").get_children()[invader_index].get_node('CollisionShape2D/RayCast2D').get_collider()):
		get_node("InvaderContainer").get_children()[invader_index].set_owner($InvaderContainer.get_owner())
		get_node("InvaderContainer").get_children()[invader_index]._shoot()
		_timer.start(rng.randf_range(3, 10))

func _add_invaders():
	var d1 = 400
	var d2 = 455
	var number_invaders = 40
	var number_rows = 2
	var step_angle = 360 / number_invaders
	for i in range(number_invaders):
		var invader = Invader.instance()
		$InvaderContainer.add_child(invader)
		invader.position = get_node("Player").position
		if i < int(number_invaders) / 2:
			invader.get_node('CollisionShape2D').position = Vector2(d1, 0)
			invader.rotation_degrees += i*step_angle*2
		else: 
			invader.get_node('CollisionShape2D').position = Vector2(d2, 0)
			invader.rotation_degrees += i*step_angle*2 + 180

func _add_blokcs():
	var d1 = 100
	var number_blocks = 4
	var step_angle = 270 / number_blocks
	for i in range(number_blocks):
		var block = Block.instance()
		$BlockContainer.add_child(block)
		block.position = get_node("Player").position
		block.rotation_degrees += i*step_angle
		block.get_node('CollisionShape2D').position = Vector2(d1, 0)
