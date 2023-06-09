extends Control

var parts = 0
var wall_parts = 0
var particlePath = preload('res://death_particles.tscn')
signal cont
signal cannonBought
signal wallBought
var cannon_price = 10
var wall_price = 15



func _on_enemy_1_died(type, pos):
	if type == 1:
		parts += 1
		$Label.text = 'Monster Parts: ' + var_to_str(parts)
	elif type == 2:
		wall_parts += 1
		$WallParts.text = 'Tough Monster Parts: ' + var_to_str(wall_parts)
		if $WallParts.visible == false:
			$WallParts.visible = true
			$GridContainer/NewWall.visible = true
	else:
		wall_parts += 20
		parts += 20
		$Label.text = 'Monster Parts: ' + var_to_str(parts)
		$WallParts.text = 'Tough Monster Parts: ' + var_to_str(wall_parts)
	spawn_death_particles(pos, type)

func spawn_death_particles(pos, type):
	var particles = particlePath.instantiate()
	particles.position = pos
	if type == 1:
		particles.color = 'white'
		particles.scale_amount_min = 0.1
		particles.scale_amount_max = 0.11
	elif type == 2:
		particles.color = 'red'
		particles.scale_amount_min = 0.2
		particles.scale_amount_max = 0.2
	elif type == 3:
		particles.color = 'green'
#		particles.scale = Vector2(3,3)
		particles.scale_amount_min = 0.5
		particles.scale_amount_max = 0.51
	
	add_child(particles)
	
	
	

func connect_enemy(name):
	var enemy = get_node(name)
	enemy.connect('died', _on_enemy_1_died)
	enemy.connect('hit', _on_hit)


func _on_button_button_down():
	$GridContainer.visible = false
	emit_signal("cont")


func _on_new_cannon_button_down():
	if parts >= cannon_price:
		parts -= cannon_price
		cannon_price += 1
		$Label.text = 'Monster Parts: ' + var_to_str(parts)
		$GridContainer/NewCannon.text = 'Cannon: ' + var_to_str(cannon_price) + ' Parts'
		emit_signal("cannonBought")


func _on_new_wall_button_down():
	if wall_parts >= wall_price:
		wall_parts -= wall_price
		wall_price += 1
		$WallParts.text = 'Tough Monster Parts: ' + var_to_str(wall_parts)
		$GridContainer/NewWall.text = 'Wall: ' + var_to_str(wall_price) + ' Tough Parts'
		emit_signal('wallBought')

func _on_hit():
	Stats.bullets_hit += 1
