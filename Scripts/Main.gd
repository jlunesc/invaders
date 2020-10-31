extends Node2D

var Invader = preload("res://Scenes/InvaderArea.tscn")
var Block = preload("res://Scenes/Blocks.tscn")
var _timer
var _timer_ditch
var rng = RandomNumberGenerator.new()

func _ready():
	# timer for the first shoot
	_timer = Timer.new()
	add_child(_timer)
	_timer.start(2)
	_timer.autostart = true

	_timer_ditch = Timer.new()
	add_child(_timer_ditch)
	_timer_ditch.start(5)
	_timer_ditch.autostart = true

	_add_invaders() 	# placement of the invaders
	_add_blokcs()

func _process(delta):
	if _timer.get_time_left() < 1:
		_invader_shoot()
		_invader_ditch()

func _invader_shoot():
	rng.randomize()
	_timer.stop()
	var list =  get_tree().get_nodes_in_group("Invaders")
	list.shuffle()
	for inv in list:
		if inv._can_shoot():
			inv.set_owner($InvaderContainer.get_owner())
			inv._shoot()
			break
	_timer.start(rng.randf_range(3, 8))

func _invader_ditch():
	rng.randomize()
	_timer_ditch.stop()
	var list =  get_tree().get_nodes_in_group("Invaders")
	list.shuffle()
	for inv in list:
		if not inv._can_shoot():
			inv.get_node('Area2D').rotation_degrees += 20
			break
	_timer_ditch.start(rng.randf_range(6, 12))

func _add_invaders():
	var d = 300
	var number_invaders = 5
	var number_rows = 5
	for j in range(number_rows):
		for i in range(number_invaders):
			var invader = Invader.instance()
			$InvaderContainer.add_child(invader)
			invader.position = get_node("Player").position
			invader.get_node("Area2D/CollisionShape2D").position = Vector2(0, d + 50*j)
			invader.get_node("Area2D").rotation_degrees += i*(360 / number_invaders)

func _add_blokcs():
	var d1 = 100
	var number_blocks = 5
	for i in range(number_blocks):
		var block = Block.instance()
		$BlockContainer.add_child(block)
		block.position = get_node("Player").position
		block.rotation_degrees += 20+i*(360 / number_blocks)
		block.get_node('CollisionShape2D').position = Vector2(d1, 0)
