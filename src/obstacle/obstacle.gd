extends MoveScroll
signal passed

var is_passed: bool = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if position.x < Global.player_x and not is_passed:
		emit_signal("passed")
		is_passed = true
