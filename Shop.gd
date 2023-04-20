extends Control

var parts = 0
var wall_parts = 0
signal cont
signal cannonBought
signal wallBought

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_1_died(type):
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
		
		
	

func connect_enemy(name):
	var enemy = get_node(name)
	enemy.connect('died', _on_enemy_1_died)


func _on_button_button_down():
	$GridContainer.visible = false
	emit_signal("cont")


func _on_new_cannon_button_down():
	if parts >= 15:
		parts -= 15
		$Label.text = 'Monster Parts: ' + var_to_str(parts)
		emit_signal("cannonBought")


func _on_new_wall_button_down():
	if wall_parts >= 15:
		wall_parts -= 15
		$WallParts.text = 'Tough Monster Parts: ' + var_to_str(wall_parts)
		emit_signal('wallBought')
