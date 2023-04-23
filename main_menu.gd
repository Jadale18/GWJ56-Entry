extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.rotation += delta


func _on_button_button_down():
	create_tween().tween_property($AudioStreamPlayer, "volume_db", -80, 1)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file('res://animation_player.tscn')
