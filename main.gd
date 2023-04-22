extends Node2D

var enemyPath = preload('res://enemy_1.tscn')
var cannonPath = preload("res://cannon.tscn")
var wallPath = preload('res://wall.tscn')
var bossPath = preload('res://boss.tscn')
var wavemode = false
var buymode = false
var enemies_exist = false
var placing_cannon = false
var placing_wall = false
var newcannon = null
var newwall = null
var can_place = true
var wave_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cannon.ableToShoot = true
	await get_tree().create_timer(2).timeout
	wavemode = true
	$EnemySpawnTimer.start()
	$WaveTimer.start()
	$AnimationPlayer.play("Waves")
	$AudioStreamPlayer.volume_db = -3


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
	if wave_counter > 3:
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
				node.rounds_left -= 1
				node.ableToShoot = false
				if node.rounds_left == 1 and node.can_die:
					get_node(node.get_path()).get_child(6).start()
			if "Wall" in node.name:
				node.starting_lifespan -= 1
				if node.starting_lifespan == 1:
					get_node(node.get_path()).get_child(2).start()


func _on_shop_cont():
	buymode = false
	wavemode = true
	$EnemySpawnTimer.start()
	$WaveTimer.start()
	$AnimationPlayer/Label.text = 'Wave ' + var_to_str(wave_counter + 1)
	$AnimationPlayer.play("Waves")
	for node in get_children():
		if "Cannon" in node.name:
			node.ableToShoot = true
	if wave_counter >= 10:
		var bosses = floor(wave_counter/5) - 1
		for boss in bosses:
			spawn_boss()

func _on_shop_cannon_bought():
	newcannon = cannonPath.instantiate()
	add_child(newcannon)
	newcannon.position = get_global_mouse_position()
	newcannon.og = false
	placing_cannon = true

func placing():
	$Shop/GridContainer.visible = false
	newcannon.position = get_global_mouse_position()
	await get_tree().create_timer(0.2).timeout
	if newcannon.overlappingCannons == 0:
		can_place = true
		get_node(newcannon.get_path()).get_child(2).visible = false
	else:
		can_place = false
		get_node(newcannon.get_path()).get_child(2).visible = true
	if Input.is_action_just_pressed("shoot") and can_place:
		placing_cannon = false
		$Shop/GridContainer.visible = true
		can_place = false
		newcannon.can_die = true


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
		
func spawn_boss():
	var boss = bossPath.instantiate()
	$Shop.add_child(boss)
	$Shop.connect_enemy(boss.get_path())
	var spawn_location = get_node("EnemyPath/EnemySpawnLocations")
	spawn_location.progress_ratio = randf()
	boss.position = spawn_location.position
	boss.velocity_dir = Vector2(576 - boss.position.x, 324 - boss.position.y).normalized()



func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play(2.0)
