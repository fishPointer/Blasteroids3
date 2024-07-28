extends Area2D

var speed: int = 2000
var direction: Vector2 = Vector2.UP

func _ready():
	pass
	var zone = randi_range(1,4)
	print(zone)
	
func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	print(body)
	body.hit()
	queue_free()
