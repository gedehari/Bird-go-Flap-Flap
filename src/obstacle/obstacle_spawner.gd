extends Node2D

var obstacle_width: int = 210
var obstacle_opening_distance: int = 315
var obstacle_distance: int = 260
var min_y: int = 500
var max_y: int = 980

var obstacle = preload("res://src/obstacle/obstacle_bottom.tscn")
var obstacle_scirpt = preload("res://src/obstacle/obstacle.gd")
var obstacle_tp: Node2D = Node2D.new()
var spawn_timer: Timer = Timer.new()

var rng_pos: RandomNumberGenerator = RandomNumberGenerator.new()

var last_spawned: Node2D
var is_active: bool = false


func _ready() -> void:
	
	## Init top bottom obstacle
	
	obstacle_tp.name = "idonthaveagirlfriendsadface"
	
	var bottom = obstacle.instance()
	obstacle_tp.add_child(bottom)
	
	var top = obstacle.instance()
	obstacle_tp.add_child(top)
	top.position.y = -obstacle_opening_distance
	top.scale.y = -1
	
	start_spawning()
	
	print(720 - obstacle_width)


func _process(delta: float) -> void:
	if last_spawned and is_active:
		if last_spawned.position.x < 720 - obstacle_distance:
			spawn()


func spawn() -> void:
	for x in range(2):
		rng_pos.randomize()
	
	last_spawned = obstacle_tp.duplicate()
	last_spawned.set_script(obstacle_scirpt)
	last_spawned.x_kill = -obstacle_width + 10
	add_child(last_spawned)
	last_spawned.position.x = 720 + obstacle_width
	last_spawned.position.y = rng_pos.randi_range(min_y, max_y)


func start_spawning() -> void:
	is_active = true
	spawn_timer.connect("timeout", self, "spawn")
	spawn_timer.one_shot = true
	spawn_timer.wait_time = 1.5
	add_child(spawn_timer)
	spawn_timer.start()
