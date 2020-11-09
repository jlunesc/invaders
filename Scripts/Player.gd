extends KinematicBody2D

export (PackedScene) var Bullet

export var velocity = 0
export var turning = 2.0

var amo_max = 4
var amo = amo_max
var _timer_amo
var can_shoot = true

var health_max = 5
var health = health_max
var health_incr = 0.05
var damage = 0.75

func _process(delta):
	_recover_health(delta)
	if Input.is_action_pressed("turn_left"):
		rotation -= turning * delta
	if Input.is_action_pressed("turn_right"):
		rotation += turning * delta
	if Input.is_action_just_pressed("shoot"):
		shoot()
	move_and_collide(Vector2.RIGHT.rotated(rotation) * velocity * delta)
	if not can_shoot:
		_reload()

func shoot():
	if can_shoot:
		$Camera2D.shake(0.25, 50, 2)
		$SoundFxs/shoot.play()
		var b = Bullet.instance()
		owner.add_child(b)
		b.transform = $Position2D.global_transform
		amo -= 1
		if amo <= 0:
			can_shoot=false
			_timer_amo = Timer.new()
			add_child(_timer_amo)
			_timer_amo.start(5)
			_timer_amo.autostart = true
	else: 
		$SoundFxs/failed_shoot.play()

func _reload():
	if _timer_amo.get_time_left() < 1:
		amo = amo_max
		can_shoot=true
		_timer_amo.stop()
		$SoundFxs/reloaded.play()

func _get_damage():
	health -= damage
	get_tree().get_current_scene().get_node('SoundFxs/impact_player').play()
	$Camera2D.shake(0.75, 150, 7.5)
	if health <= 0:
		get_tree().reload_current_scene()

func _recover_health(delta):
	if health < health_max:
		health += health_incr*delta
