extends CharacterBody2D

var speed: int = 500
var can_laser: bool = true
var can_dash: bool = true
var i: bool = true

signal laser(pos, dir)

func _ready():
	$MikuIdle.show()
	$MikuDie.hide()

func _process(_delta):
	#inputs
	if Globals.player_alive:
		$AnimationPlayer.play("idle")
		$MikuIdle.show()
		$MikuDie.hide()
		var direction = Input.get_vector("left","right","up","down")
		velocity = direction * speed
		move_and_slide()
		Globals.player_pos = global_position
		var mouse: Vector2 = get_global_mouse_position()
		if mouse.x > position.x:
			$MikuIdle.flip_h = false
		else:
			$MikuIdle.flip_h = true
			
		if Input.is_action_just_pressed("primary") and can_laser:
			can_laser = false
			$LaserCooldown.start()
			print("mikumiku beam!")
			var laser_dir: Vector2 = (get_global_mouse_position() - position).normalized()
			laser.emit(global_position, laser_dir)
			
		if Input.is_action_just_pressed("dash") and can_dash:
			can_dash = false
			$DashTimer.start()
			print("dash")
			#speed = 2000
			var dashdecay = create_tween()
			dashdecay.tween_property(self, "speed", speed, 0.20).from(2000)
	else:
		die()
		

func _on_laser_cooldown_timeout():
	can_laser = true
func _on_dash_timer_timeout():
	can_dash = true
func die():
	if i:
		$AnimationPlayer.play("die")
		i = false
