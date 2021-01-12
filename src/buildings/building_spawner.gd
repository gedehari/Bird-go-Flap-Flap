extends Node2D

var x_kill: int = -300
var modifier: float = 0.25

var buildings: Array = [
	preload("res://src/buildings/building_1.tscn"),
	preload("res://src/buildings/building_2.tscn")
]

var min_y: int = 500
var max_y: int = 980

var rng_variation: RandomNumberGenerator = RandomNumberGenerator.new()
var rng_distance: RandomNumberGenerator = RandomNumberGenerator.new()

var last_spawned: Sprite
var last_choice: int = 0


func _ready() -> void:
	$Building1.x_kill = x_kill
	$Building1.modifier = modifier
	
	$Building2.x_kill = x_kill
	$Building2.modifier = modifier
	
	spawn()


func _process(delta: float) -> void:
	if last_spawned:
		if last_spawned.position.x < 720 - rng_distance.randi_range(100, 350):
			spawn()


func spawn() -> void:	
	var choice: int = rng_variation.randi_range(0, 1)
	
	last_spawned = buildings[choice].instance()
	last_spawned.x_kill = x_kill
	last_spawned.modifier = modifier
	add_child(last_spawned)
	last_spawned.position.x = 720
