extends Node2D
class_name MoveScroll

var x_kill: int = 0
var modifier: float = 1


func _process(delta: float) -> void:
	position.x -= (Global.current_speed * modifier) * delta
	
	if position.x < x_kill:
		queue_free()
