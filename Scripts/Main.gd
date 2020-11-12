extends Node2D

var FinalBoss = preload("res://Scenes/FinalBoss.tscn")
var FBigBoss = preload("res://Scenes/BigBoss1.tscn")
var Invader = preload("res://Scenes/InvaderArea.tscn")
var Block = preload("res://Scenes/Blocks.tscn")
var DestructibleBlock = preload("res://Scenes/DestructibleBlock.tscn")
var _timer_shoot
var _timer_ditch
var rng = RandomNumberGenerator.new()

var time_start = 0
var time_now = 0
var _reference_time

var score = 0
var _n_invaders_killed = 0
var _invaders_to_kill = 4

var _bonification = 4

var d1 = 100 # distance of the blocks
var d = 200 # distance of the invaders
var number_invaders = 7
var number_rows = 3
var space_between_rows = 50 # of invaders

func _ready():
	var _signal_connected = get_node("Player").connect("player_is_dead", self, "GameOver")
	
	$Instructions.visible = true
	$GameOver.visible = false
	time_start = OS.get_unix_time()
	_reference_time = time_start
	
	# timer for the first shoot
	_timer_shoot = Timer.new()
	add_child(_timer_shoot)
	_timer_shoot.start(6)
	_timer_shoot.autostart = true

	_timer_ditch = Timer.new()
	add_child(_timer_ditch)
	_timer_ditch.start(5)
	_timer_ditch.autostart = true

	_add_invaders(d, number_invaders, number_rows) 	# placement of the invaders
	_add_blokcs(d1, number_invaders)
	
	yield(get_tree().create_timer(2.5), "timeout")
	$Instructions.visible = false

func _process(_delta):
	if _timer_shoot.get_time_left() < 1:
		_invader_shoot()
	if _timer_ditch.get_time_left() < 1:
		_invader_ditch()

	_play_sound_track()
	_add_bigboss1()
	_apply_bonification()
	_add_final_boss()

func _input(_event):
	if Input.is_action_just_pressed("retry"):
		get_tree().reload_current_scene()

func _invader_shoot():
	rng.randomize()
	_timer_shoot.stop()
	var list =  get_tree().get_nodes_in_group("Invaders")
	list.shuffle()
	for inv in list:
		if inv._can_shoot():
			inv.set_owner($InvaderContainer.get_owner())
			inv._shoot()
			$SoundFxs/shoot_invader.play()
			break
	time_now =  (OS.get_unix_time()-_reference_time) / 60.0
	var b = pow(10, -0.5)
	var factor = 1.0 / (1.0 + pow(time_now/b,3))
	if factor > 0.6:
		_normality(factor)
	elif factor < 4.0:
		_set_armagedon()

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

func _add_invaders(_d, _number_invaders, _number_rows):
	for j in range(_number_rows):
		for i in range(_number_invaders):
			var invader = Invader.instance()
			$InvaderContainer.add_child(invader)
			invader.position = get_node("Player").position
			invader.get_node("Area2D/CollisionShape2D").position = Vector2(0, _d + space_between_rows*j)
			invader.get_node("Area2D").rotation_degrees += i*(360 / _number_invaders)

func _add_blokcs(_d1, number_blocks):
	for i in range(number_blocks):
		var block = DestructibleBlock.instance()
		$BlockContainer.add_child(block)
		block.position = get_node("Player").position
		block.rotation_degrees += 20+i*(360 / number_blocks)
		block.get_node("Node2D").position = Vector2(_d1, 0)

func _normality(factor):
	_timer_shoot.start(rng.randf_range(5, 10)*factor)

func _set_armagedon():
	yield(get_tree().create_timer(0.15), "timeout")
	_reference_time = OS.get_unix_time()

func _make_explosion(position):
	var new_explosion = $explosion.duplicate()
	add_child(new_explosion)
	new_explosion.position = position
	new_explosion.playing = true
	yield(get_tree().create_timer(0.33), "timeout")
	new_explosion.queue_free()

func _play_sound_track():
	if not $Music/SoundTrack.is_playing():
		$Music/SoundTrack.play()

func _add_bigboss1():
	if _n_invaders_killed > _invaders_to_kill:
		var _d = d+10
		var _number_rows = number_rows
		var fbigboss = FBigBoss.instance()
		$InvaderContainer.add_child(fbigboss)
		fbigboss.position = get_node("Player").position
		fbigboss.get_node("Area2D/CollisionShape2D/RayCast2D").cast_to = Vector2(0, space_between_rows*(_number_rows))
		fbigboss.get_node("Area2D/CollisionShape2D").position = Vector2(0, _d + space_between_rows*(_number_rows))
		
		_invaders_to_kill += 0
		_n_invaders_killed = 0

func _add_final_boss():
	if $InvaderContainer.get_child_count() == 0:
		var final_boss = FinalBoss.instance()
		$InvaderContainer.add_child(final_boss)
		final_boss.connect("final_boss_dead", self, '_you_win')
		final_boss.position = get_node("Player").position

func _apply_bonification():
	if score > _bonification:
		get_node('Player').amo_max += 2
		get_node('Player/SoundFxs/reloaded').play()
		_bonification += 3.5

func GameOver():
	get_node('GameOver').visible = true
	for node in $InvaderContainer.get_children():
		node.queue_free()
	for node in $BlockContainer.get_children():
		node.queue_free()
	$Player.set_process(false)
	set_process(false)

func _you_win():
	get_node("YouWin").visible = true
	for node in $BlockContainer.get_children():
		node.queue_free()
	$Player.set_process(false)
	$InvaderContainer.get_child(0).set_process(false)
