extends CanvasLayer

var score: int = 0
var can_retry: bool = false


func _ready() -> void:
	Global.main = self
	
	if not Global.first_game:
		Global.current_speed = Global.default_speed
		$Container/ObstacleSpawner.start_spawning()


func _input(event: InputEvent) -> void:
	if event:
		if event is InputEventScreenTouch or Input.is_action_just_pressed("flap"):
			if can_retry:
				get_tree().reload_current_scene()
			if Global.first_game:
				Global.first_game = false
				$Container/ObstacleSpawner.start_spawning()
		


func _on_obstacle_passed() -> void:
	score += 1
	$Score.text = str(score)
