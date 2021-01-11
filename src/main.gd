extends CanvasLayer

var score: int = 0


func _ready() -> void:
	Global.main = self


func _on_obstacle_passed() -> void:
	score += 1
	print(score)
