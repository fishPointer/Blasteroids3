extends CharacterBody2D

var speed: int = 200
signal deadskull
var lasered: bool = false

func _process(delta):
	look_at(Globals.player_pos)
	
	if abs(rotation_degrees) > 90:
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false
	var dir = (Globals.player_pos - position).normalized()
	
	if global_position.distance_to(Globals.player_pos) < 500:
		var speedtween = create_tween()
		speedtween.tween_property(self, "speed", 500, 2)
	
	velocity = speed * dir
	var collision = move_and_collide(velocity * delta)
	if lasered:
		deadskull.emit()
		print("skullcrashed!")
		queue_free()
	if collision:
		print(collision)
		queue_free()
		Globals.player_alive = false
		
func hit():
	lasered = true
