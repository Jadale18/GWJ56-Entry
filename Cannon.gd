extends Node2D

const bulletPath = preload('res://bullet.tscn')
var shooting = false
var ableToShoot = false
var overlappingCannons = 0
var can_die = false
var rounds_left = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_death()
	if ableToShoot:
		look_at(get_global_mouse_position())
		check_input()
	
func check_input():
	if Input.is_action_pressed("shoot") and not shooting:
		shoot()

func check_death():
	if rounds_left == 0 and can_die == true:
		queue_free()
		
func shoot():
	shooting = true
	$Timer.start()
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Marker2D.global_position
	bullet.rotation = rotation_degrees
	bullet.velocity = (get_global_mouse_position() - bullet.position).normalized()
	


func _on_timer_timeout():
	shooting = false


func _on_area_2d_area_entered(area):
	if area.name == "CannonArea":
		overlappingCannons += 1
	elif area.name == 'EnemyArea':
		queue_free()



func _on_cannon_area_area_exited(area):
	if area.name == "CannonArea":
		overlappingCannons -= 1



func _on_dying_timer_timeout():
	$Sprite2D.visible = not $Sprite2D.visible
	$Dying.visible = not $Dying.visible
