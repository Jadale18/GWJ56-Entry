extends AnimationPlayer

func _ready():
	play("Text1")


func _on_button_button_down():
	$Button.visible = false
	get_tree().change_scene_to_file('res://main.tscn')


func _on_button_2_button_down():
	get_tree().change_scene_to_file('res://main.tscn')
