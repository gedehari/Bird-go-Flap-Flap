extends MoveScroll
signal passed

var is_passed: bool = false


func _ready() -> void:
	if Global.main:
		connect("passed", Global.main, "_on_obstacle_passed")


func _process(delta: float) -> void:
	if Global.main: if not Global.main.is_dead:
		if (position.x + 100) < Global.player_x and not is_passed:
			emit_signal("passed")
			is_passed = true
