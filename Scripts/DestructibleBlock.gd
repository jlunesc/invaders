extends Node2D

var units = preload("res://Scenes/UnitBlocks.tscn")

export var velocity = 0
export var turning = 2.0

var len_x = 6
var len_y = 2
var size_square = 5

var rng = RandomNumberGenerator.new()

func _ready():
	$Node2D.position = Vector2(100,0)
	for child in $Node2D.get_children():
		child.add_to_group('DestructibleBlock')
	_make_shields(len_x, len_x, size_square)

func _process(delta):
	if Input.is_action_pressed("block_turn_left"):
		rotation -= turning * delta
	if Input.is_action_pressed("block_turn_right"):
		rotation += turning * delta
	
func _make_shields(len_x, len_y, size_square):
	rng.randomize()
	for i in range(len_x):
		for j in range(len_y):
			var b_unit = units.instance()
			$Node2D.add_child(b_unit)
			b_unit.add_to_group('DestructibleBlock')
			b_unit.scale = Vector2(0.5, 0.5)
			var ran_x = rng.randfn(0, 1)
			var ran_y = rng.randfn(0, 1)
			b_unit.position = -Vector2(ran_x+i-len_x*0.5,ran_y+j-len_y*0.5)*size_square
			b_unit.rotation_degrees = rng.randf_range(0, 360)
