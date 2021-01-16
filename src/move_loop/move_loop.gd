extends Node2D
class_name MoveLoop

export var x_loop: int = 0
export var modifier: float = 1


func _process(delta: float) -> void:
	position.x -= (Global.current_speed * modifier) * delta
	
	if position.x < x_loop:
		position.x = position.x - x_loop
