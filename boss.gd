extends CharacterBody2D

var health = 50
var velocity_dir = Vector2.RIGHT
var speed = 30
signal died(material)

func _physics_process(delta):
	velocity = velocity_dir * speed
	move_and_slide()
	check_health()

func check_health():
	$Label.text = var_to_str(health)
	if health <= 0:
		emit_signal('died', 3)
		queue_free()

func _on_boss_area_area_entered(area):
	if area.name == 'Bunker':
		queue_free()
	elif 'Bullet' in area.name:
		health -= 1
