extends Area2D

var velocity = Vector2.ZERO
var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta * velocity.y
	position.x += speed * delta * velocity.x
	
	check_screen()
	
func check_screen():
	if position.x > 1156 or position.x < 0 or position.y > 648 or position.y < 0:
		queue_free()


func _on_area_entered(area):
	if area.name == 'EnemyArea' or area.name == "BossArea":
		queue_free()
