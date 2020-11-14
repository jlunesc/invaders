extends Node2D

signal final_boss_dead
signal damage_received

export (PackedScene) var Bullet

export var velocity = 0
export var rotation_speed = 1.0

var _timer_direction
var change_direction = 10
var time_start
var time_now

var _mean_distance = 300
var direction = 1.0

var max_health = 5
var health = max_health
var health_incr = 0.01

var _keep_shooting = true

var rng = RandomNumberGenerator.new()

func _ready():
	add_to_group('final_boss')
	get_node('Area2D/CollisionShape2D').position.y += _mean_distance
	rng.randomize()
	_timer_direction = Timer.new()
	add_child(_timer_direction)
	_timer_direction.start(rng.randfn(change_direction,3))
	_timer_direction.autostart = true
	
	time_start = OS.get_unix_time()

func _process(delta):
	_move(delta)

func _move(delta):
	# moving mechanics
	_change_direction()
	time_now =  (OS.get_unix_time()-time_start)
	$Area2D.rotation += rotation_speed * delta * direction
	get_node('Area2D/CollisionShape2D').position.y += 2.5*sin(10*time_now)
	
	# shooting mechanics
	if get_node('Area2D/CollisionShape2D').position.y < _mean_distance*0.8:
		if _keep_shooting:
			for _i in range(1):
				_shoot()
			_keep_shooting=false
	elif get_node('Area2D/CollisionShape2D').position.y > _mean_distance*0.8:
		_keep_shooting=true

func _shoot():
	var b = Bullet.instance()
	b.damage_bullet = 1.5
	b.modulate = Color('710957')
	b.speed = 350
	add_child(b)
	b.transform = $Area2D/CollisionShape2D/Position2D.global_transform
	get_tree().get_current_scene().get_node('SoundFxs/shoot_invader').play()

func _change_direction():
	if _timer_direction.get_time_left() < 0.5:
		rng.randomize()
		var old_direction = direction
		direction = old_direction*(-1.0)
		_timer_direction.start(rng.randfn(change_direction,3))

func _get_damage(damage_received):
	health -= damage_received
	rotation_speed += 0.15
	get_tree().get_current_scene().get_node('Player/Camera2D').shake(0.5, 150, 7.5)
	emit_signal('damage_received')
	if health <= 0:
		emit_signal("final_boss_dead")

func _recover_health(delta):
	if health < max_health:
		health += health_incr*delta
