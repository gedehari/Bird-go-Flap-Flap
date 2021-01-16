extends Node

var first_game: bool = true

var default_speed: int = 325
var current_speed: int = default_speed

var player_x: int

var last_bg_mod: Color = Color.white
var last_tod_mod: Color = Color.white

var main: CanvasLayer


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("screenshot"):
		var image: Image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("user://bruhshot.png")
