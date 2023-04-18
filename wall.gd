extends StaticBody2D

@export var starting_lifespan = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if starting_lifespan == 0:
		queue_free()


func _on_timer_timeout():
	$Sprite2D.visible = not $Sprite2D.visible
	$Sprite2D2.visible = not $Sprite2D2.visible
