extends Area2D

var health = 10
@export var labvis = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if not labvis:
		$Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_health()
	

func update_health():
	$Label.text = var_to_str(health)
	if health == 0:
		get_tree().change_scene_to_file("res://game_over.tscn")


func _on_area_entered(area):
	if area.name == 'EnemyArea' or area.name == 'BossArea':
		health -= 1
