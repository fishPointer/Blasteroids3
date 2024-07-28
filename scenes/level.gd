extends Node2D

var laser_scene: PackedScene = preload("res://scenes/laser.tscn")
var skull_scene: PackedScene = preload("res://scenes/skull.tscn")
var player_scene: PackedScene = preload("res://scenes/player.tscn")
var window_x: int = 1366
var window_y: int = 768
var rand_band: int = 200
var skullcount: int = 2
var score: int = 1

func create_laser(pos, dir):
	var laser = laser_scene.instantiate()
	laser.position = pos
	laser.direction = dir
	laser.rotation = dir.angle()
	$Projectiles.add_child(laser)

func create_skull():
	print("new skull")
	score += 1
	var skull = skull_scene.instantiate()
	skull.position = random_zone_select()
	$Enemies.add_child(skull)
	skull.connect("deadskull", create_skull)
	if randi_range(1,10) == 5:
		create_skull()
	skullcount = $Enemies.get_child_count()


	
	
	
func _ready():
	for entity in get_tree().get_nodes_in_group("Entity"):
		print(entity)
		entity.connect("laser", create_laser)
	for skull in get_tree().get_nodes_in_group("Skull"):
		print(skull)
		skull.connect("deadskull", create_skull)
	$TextureRect/Control/Button.hide()
		
func _process(delta):
		if skullcount > 10:
			for skull_i in get_tree().get_nodes_in_group("Skull"):
				skull_i.queue_free()
			create_skull()
		$Control/VBoxContainer/HBoxContainer2/Score.text = str(score)
		$Control/VBoxContainer/HBoxContainer/Count.text = str(skullcount)
		
		if not Globals.player_alive:
			for skull_i in get_tree().get_nodes_in_group("Skull"):
				skull_i.queue_free()
			$TextureRect/Control/Button.show()
			$TextureRect/Control/TextureRect2.modulate = Color("00000000")
			$TextureRect/Control/TextureRect2.show()
			var dietween = create_tween()
			dietween.tween_property($TextureRect/Control/TextureRect2, "modulate", Color("000000d5"), 1)
				
			
		
func random_zone_select():
	var gen_x: int
	var gen_y: int
	var zone = randi_range(1,4)
	print("zone:", zone)
	if zone == 1:
		gen_x = randi_range(-rand_band, 0)
		gen_y = randi_range(-rand_band, window_y+rand_band)
	if zone == 2:
		gen_x = randi_range(window_x, window_x+rand_band)
		gen_y = randi_range(-rand_band, window_y+rand_band)
	if zone == 3:
		gen_x = randi_range(-rand_band, window_x+rand_band)
		gen_y = randi_range(-rand_band, 0)
	if zone == 4:
		gen_x = randi_range(-rand_band, window_x+rand_band)
		gen_y = randi_range(window_y, window_y+rand_band)
	print("x: ", gen_x, " - y: ", gen_y)
	return Vector2(gen_x, gen_y)
		


func _on_button_pressed():
	print("button")
	Globals.player_alive = true
	print(Globals.player_alive)
	score = 0
	skullcount = 1
	create_skull()
	$TextureRect/Control/Button.hide()
	$Player.global_position = Vector2(683, 384)
	var livetween = create_tween()
	livetween.tween_property($TextureRect/Control/TextureRect2, "modulate", Color("00000000"), 0.5)
	await livetween.finished
	$TextureRect/Control/TextureRect2.hide()
