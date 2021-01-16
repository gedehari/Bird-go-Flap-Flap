extends CanvasLayer

var score: int = 0
var can_retry: bool = false
var is_dead: bool = false

var day_or_night: bool = true

onready var tod_playerlight: Light2D = $ScreenCenter/LightLayer/Player/TodLight
onready var tod_sunmoon: Sprite = $ScreenCenter/SunMoon
onready var tod_sunlight: Light2D = $ScreenCenter/SunMoon/SunLight
onready var tod_moonglow: Sprite = $ScreenCenter/SunMoon/MoonGlow

var sun_tex: StreamTexture = preload("res://res/textures/sun.png")
var moon_tex: StreamTexture = preload("res://res/textures/moon.png")


func _ready() -> void:
	_on_resize()
	
	Global.main = self
	
	get_tree().connect("screen_resized", self, "_on_resize")
	
	if not Global.first_game:
		tod_sunlight.show()
		
		Global.current_speed = Global.default_speed
		
		$Tween2.interpolate_property($Background, "color", Global.last_bg_mod, Color.white, 1.75)
		$Tween2.interpolate_property($ScreenCenter/LightLayer/TodMod, "color", Global.last_tod_mod, Color.white, 1.75)
		$Tween2.start()
		$ScreenCenter/LightLayer/ObstacleSpawner.start_spawning()
		
		yield($Tween2, "tween_all_completed")
		
		tod_sunlight.hide()


func _input(event: InputEvent) -> void:
	if event:
		if event is InputEventScreenTouch or Input.is_action_just_pressed("flap"):
			if can_retry:
				Global.last_bg_mod = $Background.color
				Global.last_tod_mod = $ScreenCenter/LightLayer/TodMod.color
				get_tree().reload_current_scene()
			if Global.first_game:
				Global.first_game = false
				$ScreenCenter/LightLayer/ObstacleSpawner.start_spawning()


func time_of_day(to: bool) -> void:
	if not to:
		tod_sunlight.show()
		
		$Tween2.interpolate_property($Background, "color", Color.white, Color.black, 2.2)
		$Tween2.interpolate_property($ScreenCenter/LightLayer/TodMod, "color", Color.white, Color(0.15, 0.15, 0.15), 2.2)
		$Tween2.start()
		
		$Tween.interpolate_property($ScreenCenter/TodRotRt, "rotation_degrees", 0, -55, 2, Tween.TRANS_BACK, Tween.EASE_IN)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		tod_sunmoon.texture = moon_tex
		tod_playerlight.show()
		tod_sunlight.hide()
		tod_moonglow.show()
		$Tween.interpolate_property($ScreenCenter/LightLayer/Player/TodLight, "energy", 0, 1, 1.5)
		$Tween.interpolate_property($ScreenCenter/TodRotRt, "rotation_degrees", 75, 0, 2, Tween.TRANS_BACK, Tween.EASE_OUT)
		$Tween.start()
	else:
		$Tween2.interpolate_property($Background, "color", Color.black, Color.white,  2.2)
		$Tween2.interpolate_property($ScreenCenter/LightLayer/TodMod, "color", Color(0.15, 0.15, 0.15), Color.white, 2.2)
		$Tween2.interpolate_property($ScreenCenter/LightLayer/Player/TodLight, "energy", 1, 0, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.75)
		$Tween2.start()
		
		$Tween.interpolate_property($ScreenCenter/TodRotRt, "rotation_degrees", 0, -55, 2, Tween.TRANS_BACK, Tween.EASE_IN)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		tod_sunmoon.texture = sun_tex
		tod_playerlight.hide()
		tod_sunlight.show()
		tod_moonglow.hide()
		$Tween.interpolate_property($ScreenCenter/TodRotRt, "rotation_degrees", 75, 0, 2, Tween.TRANS_BACK, Tween.EASE_OUT)
		$Tween.start()
		yield($Tween, "tween_all_completed")


func _on_obstacle_passed() -> void:
	score += 1
	
	if not score % 25:
		day_or_night = !day_or_night
		time_of_day(day_or_night)
	
	$UI/ScreenCenter/CenterContainer/Score.text = str(score)


func _on_player_dead() -> void:
	is_dead = true
	
	$UI/DeathFlash.show()
	$Tween3.interpolate_property(Global, "current_speed", Global.current_speed, 0, 0.75)
	$Tween3.interpolate_property($UI/DeathFlash, "color:a", 1, 0, 0.65)
	$Tween3.start()
	
	yield(get_tree().create_timer(1), "timeout")
	
	$UI/DeathFlash.hide()
	can_retry = true


func _on_resize() -> void:
	$ScreenCenter/LightLayer.offset.y = $ScreenCenter.rect_global_position.y
