extends CharacterBody2D

var health = 5
@export var velocity_dir = Vector2.RIGHT
@export var labels_visible = true
var speed = 100
signal died(material, where)
var type = 1

func _ready():
	await get_tree().create_timer(0.2).timeout
	if type == 1:
		$AnimatedSprite2D.animation = 'default'
		health = 5
	else:
		$AnimatedSprite2D.animation = 'hardenemy'
		health = 20
	$AnimatedSprite2D.play()
	if labels_visible:
		$Label.visible = true
	else:
		$Label.visible = false
	
func _physics_process(delta):
	velocity = velocity_dir * speed
	move_and_slide()
#	check_stuck()
	check_health()

func check_health():
	$Label.text = var_to_str(health)
	if health <= 0:
		emit_signal('died', type, position)
		queue_free()
	if position.x > 1400 or position.x < -300 or position.y > 900 or position.y < -300:
		queue_free()
	
func check_stuck():
	if get_real_velocity() == Vector2.ZERO or get_real_velocity().length() < 0.1:
		print('stuck')
		if abs(velocity_dir.x) > abs(velocity_dir.y):
			position.y += 2
		else:
			position.x += 2

		


func _on_area_2d_area_entered(area):
	if area.name == 'Bunker':
		queue_free()
	elif 'Bullet' in area.name:
		health -= 1
