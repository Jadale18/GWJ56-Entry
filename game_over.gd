extends Control

func _ready():
	if Stats.wallsbought != 0:
		$Label3.text = 'Cannons Bought: ' + var_to_str(Stats.cannonsbought) + '\nWalls Bought: ' + var_to_str(Stats.wallsbought) + '\nBullets Shot: ' + var_to_str(Stats.bullets) + '\nBullet Accuracy: ' + var_to_str(snapped((float(Stats.bullets_hit) / Stats.bullets) * 100, 0.01)) + '%'
	else:
		$Label3.text = 'Cannons Bought: ' + var_to_str(Stats.cannonsbought) + '\nBullets Shot: ' + var_to_str(Stats.bullets) + '\nBullet Accuracy: ' + var_to_str(snapped((float(Stats.bullets_hit) / Stats.bullets) * 100, 0.01)) + '%'

func _on_button_button_down():
	get_tree().change_scene_to_file('res://main_menu.tscn')
