extends AnimationPlayer

func _ready():
	play("Text1")
	$Label5.text = "Hey neighbor! If you're reading this then my experiment\nfailed and the whole world has turned into monsters \n(except you). They are going to come for you and you\nmust be able to defend yourself. Luckily, I designed the\nmonsters so that you can make tools and weapons \nfrom their parts, but they'll break after some time. \nI've already installed one on top of your house, so \nuse that to get started. Use the mouse to aim and fire \nit. Good luck out there and don't get consumed!\nSincerely - the worst neighbor"


func _on_button_button_down():
	$Button.visible = false
	get_tree().change_scene_to_file('res://main.tscn')


func _on_button_2_button_down():
	get_tree().change_scene_to_file('res://main.tscn')
