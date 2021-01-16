extends CanvasLayer

var score: int = 0
var can_retry: bool = false
var is_dead: bool = false

var day_or_night: bool = true

onready var score_label = $UI/ScreenCenter/CenterContainer/Score
onready var score_label_container = $UI/ScreenCenter/CenterContainer

onready var tod_playerlight: Light2D = $ScreenCenter/LightLayer/Player/TodLight
onready var tod_sunmoon: Sprite = $ScreenCenter/SunMoon
onready var tod_sunlight: Light2D = $ScreenCenter/SunMoon/SunLight
onready var tod_moonglow: Sprite = $ScreenCenter/SunMoon/MoonGlow

onready var score_text: Sprite = $UI/ScreenCenter/ScoreText
onready var score_pos: Position2D = $UI/ScreenCenter/ScorePos
onready var gameover_cover: ColorRect = $UI/GameOverCover

onready var intro = $ScreenCenter/LightLayer/Intro
onready var intro_hint_anim = $ScreenCenter/LightLayer/Intro/Hint/AnimationPlayer

var sun_tex: StreamTexture = preload("res://res/textures/sun.png")
var moon_tex: StreamTexture = preload("res://res/textures/moon.png")


func _ready() -> void:
	_on_resize()
	
	Global.main = self
	
	get_tree().connect("screen_resized", self, "_on_resize")
	
	if not Global.first_game:
		score_label.show()
		intro.hide()
		
		tod_sunlight.show()
		
		Global.current_speed = Global.default_speed
		
		$Tween2.interpolate_property($Background, "color", Global.last_bg_mod, Color.white, 1)
		$Tween2.interpolate_property($ScreenCenter/LightLayer/TodMod, "color", Global.last_tod_mod, Color.white, 1)
		$Tween2.start()
		$ScreenCenter/LightLayer/ObstacleSpawner.start_spawning()
		
		yield($Tween2, "tween_all_completed")
		
		tod_sunlight.hide()
	else:
		score_label.hide()
		intro.show()
		
		if OS.has_feature("mobile"):
			intro_hint_anim.play("touchhint")
		else:
			intro_hint_anim.play("arrowhint")


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
				
				score_label.show()
				$Tween2.interpolate_property(intro, "modulate:a", 1, 0, 0.5)
				$Tween2.interpolate_property(score_label, "rect_position:y", score_label.rect_position.y - 100, score_label.rect_position.y, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
				$Tween2.start()
				
				yield($Tween2, "tween_all_completed")
				
				intro.hide()


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
		$Tween2.interpolate_property($Background, "color", Color.black, Color.white, 2.2)
		$Tween2.interpolate_property($ScreenCenter/LightLayer/TodMod, "color", Color(0.15, 0.15, 0.15), Color.white, 2.2)
		$Tween2.interpolate_property($ScreenCenter/LightLayer/Player/TodLight, "energy", 1, 0, 1)
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
	
	score_label.text = str(score)


func _on_player_dead() -> void:
	is_dead = true
	
	var color: Color
	var color_fg: Color
	if day_or_night:
		color = Color.white
		color_fg = Color.black
	else:
		color = Color.black
		color_fg = Color.white
	score_text.modulate.a = 0
	score_text.modulate = color_fg
	
	$UI/DeathFlash.show()
	$Tween3.interpolate_property(Global, "current_speed", Global.current_speed, 0, 0.75)
	$Tween3.interpolate_property($UI/DeathFlash, "color:a", 1, 0, 0.65)
	$Tween3.start()
	
	yield(get_tree().create_timer(0.75), "timeout")
	
	$UI/DeathFlash.hide()
	
	gameover_cover.show()
	score_text.show()
	$Tween3.interpolate_property(gameover_cover, "color", Color(color.r, color.g, color.b, 0), Color(color.r, color.g, color.b, 0.8), 0.4)
	$Tween3.interpolate_property(score_text, "modulate:a", 0, 1, 0.4)
	$Tween3.interpolate_property(score_label_container, "rect_position:y", score_label_container.rect_position.y, score_pos.position.y, 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Tween3.start()
	
	can_retry = true


func _on_resize() -> void:
	$ScreenCenter/LightLayer.offset.y = $ScreenCenter.rect_global_position.y
