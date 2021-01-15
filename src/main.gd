extends CanvasLayer

var score: int = 0
var can_retry: bool = false

var day_or_night: bool = true

onready var tod_sunmoon: Sprite = $Container/SunMoon
onready var tod_sunlight: Light2D = $Container/SunMoon/SunLight
onready var tod_moonglow: Sprite = $Container/SunMoon/MoonGlow

var sun_tex: StreamTexture = preload("res://res/textures/sun.png")
var moon_tex: StreamTexture = preload("res://res/textures/moon.png")


func _ready() -> void:
	Global.main = self
	
	if not Global.first_game:
		Global.current_speed = Global.default_speed
		$Container/LightLayer/ObstacleSpawner.start_spawning()


func _input(event: InputEvent) -> void:
	if event:
		if event is InputEventScreenTouch or Input.is_action_just_pressed("flap"):
			if can_retry:
				get_tree().reload_current_scene()
			if Global.first_game:
				Global.first_game = false
				$Container/LightLayer/ObstacleSpawner.start_spawning()


func time_of_day(to: bool) -> void:
	if not to:
		$Tween2.interpolate_property($Background, "color", Color.white, Color.black, 2.2)
		$Tween2.interpolate_property($Container/LightLayer/TodMod, "color", Color.white, Color(0.15, 0.15, 0.15), 2.2)
		$Tween2.start()
		
		$Tween.interpolate_property($Container/TodRotRt, "rotation_degrees", 0, -55, 2, Tween.TRANS_BACK, Tween.EASE_IN)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		tod_sunmoon.texture = moon_tex
		tod_sunlight.hide()
		tod_moonglow.show()
		$Tween.interpolate_property($Container/LightLayer/Player/TodLight, "energy", 0, 1, 1.5)
		$Tween.interpolate_property($Container/TodRotRt, "rotation_degrees", 75, 0, 2, Tween.TRANS_BACK, Tween.EASE_OUT)
		$Tween.start()
	else:
		$Tween2.interpolate_property($Background, "color", Color.black, Color.white,  2.2)
		$Tween2.interpolate_property($Container/LightLayer/TodMod, "color", Color(0.15, 0.15, 0.15), Color.white, 2.2)
		$Tween2.interpolate_property($Container/LightLayer/Player/TodLight, "energy", 1, 0, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.75)
		$Tween2.start()
		
		$Tween.interpolate_property($Container/TodRotRt, "rotation_degrees", 0, -55, 2, Tween.TRANS_BACK, Tween.EASE_IN)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		tod_sunmoon.texture = sun_tex
		tod_sunlight.show()
		tod_moonglow.hide()
		$Tween.interpolate_property($Container/TodRotRt, "rotation_degrees", 75, 0, 2, Tween.TRANS_BACK, Tween.EASE_OUT)
		$Tween.start()


func _on_obstacle_passed() -> void:
	score += 1
	
	if not score % 25:
		day_or_night = !day_or_night
		time_of_day(day_or_night)
	
	$UI/Score.text = str(score)
