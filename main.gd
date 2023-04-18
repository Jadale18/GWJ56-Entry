extends Node2D

var enemyPath = preload('res://enemy_1.tscn')
var cannonPath = preload("res://cannon.tscn")
var wallPath = preload('res://wall.tscn')
var wavemode = false
var buymode = false
var enemies_exist = false
var placing_cannon = false
var placing_wall = false
var newcannon = null
var newwall = null
var can_place = true
var wave_counter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cannon.ableToShoot = true
	await get_tree().create_timer(2).timeout
	wavemode = true
	$EnemySpawnTimer.start()
	$WaveTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemies_exist:
		check_living_enemies()
	if placing_cannon:
		placing()
	if placing_wall:
		placing_w()
	
func _on_timer_timeout():
	var enemy = enemyPath.instantiate()
	$Shop.add_child(enemy)
	var typee = 1
	if wave_counter > 6:
		typee = randi_range(1,2)
	get_node(enemy.get_path()).type = typee
	$Shop.connect_enemy(enemy.get_path())
	var spawn_location = get_node("EnemyPath/EnemySpawnLocations")
	spawn_location.progress_ratio = randf()
	enemy.position = spawn_location.position
	enemy.velocity_dir = Vector2(576 - enemy.position.x, 324 - enemy.position.y).normalized()
	if typee == 1:
		enemy.speed = randf_range(40,80)
	elif typee == 2:
		enemy.speed = randf_range(10,50)
	


func _on_wave_timer_timeout():
	print('Wave ' + var_to_str(wave_counter) + ' Complete')
	wave_counter += 1
	$EnemySpawnTimer.stop()
	$EnemySpawnTimer.wait_time *= 0.9
	wavemode = false
	$WaveTimer.stop()
	enemies_exist = true

func check_living_enemies():
	buymode = true
	for node in $Shop.get_children():
		if 'Enemy' in node.name:
			buymode = false
	if buymode:
		$Shop/GridContainer.visible = true
		enemies_exist = false
		for node in get_children():
			if "Cannon" in node.name:
				node.ableToShoot = false
			if "Wall" in node.name:
				node.starting_lifespan -= 1
				if node.starting_lifespan == 1:
					get_node(node.get_path()).get_child(3).start()


func _on_shop_cont():
	print('New Wave')
	buymode = false
	wavemode = true
	$EnemySpawnTimer.start()
	$WaveTimer.start()
	for node in get_children():
		if "Cannon" in node.name:
			node.ableToShoot = true

func _on_shop_cannon_bought():
	newcannon = cannonPath.instantiate()
	add_child(newcannon)
	newcannon.position = get_global_mouse_position()
	placing_cannon = true

func placing():
	$Shop/GridContainer.visible = false
	newcannon.position = get_global_mouse_position()
	await get_tree().create_timer(0.2).timeout
	if newcannon.overlappingCannons == 0:
		can_place = true
		get_node(newcannon.get_path()).get_child(1).visible = false
	else:
		can_place = false
		get_node(newcannon.get_path()).get_child(1).visible = true
	if Input.is_action_just_pressed("shoot") and can_place:
		placing_cannon = false
		$Shop/GridContainer.visible = true
		can_place = false


func _on_shop_wall_bought():
	newwall = wallPath.instantiate()
	add_child(newwall)
	newwall.position = get_global_mouse_position()
	placing_wall = true

func placing_w():
	$Shop/GridContainer.visible = false
	newwall.position = get_global_mouse_position()
	if Input.is_action_pressed('ui_right') or Input.is_action_pressed('Rotate_R'):
		newwall.rotation += 0.05
	if Input.is_action_pressed('ui_left') or Input.is_action_pressed('Rotate_L'):
		newwall.rotation -= 0.05
	await get_tree().create_timer(0.2).timeout
	if Input.is_action_just_pressed("shoot"):
		placing_wall = false
		$Shop/GridContainer.visible = true
