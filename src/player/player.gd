extends Area2D

const GRAVITY = 75
const MOTION_LIMIT = 50
const GROUND_Y = 1280

const FLAP_FORCE = 22

var can_move = false

var y_motion: float = 0
var on_ground: bool = true

var can_die: bool = true
var is_dead: bool = false


func _ready() -> void:
	if not Global.first_game:
		can_move = true
		flap()
	
	Global.player_x = position.x


func _process(delta: float) -> void:
	$Sprite.rotation_degrees = y_motion * 0.6


func _physics_process(delta: float) -> void:
	if can_move:
		y_motion += GRAVITY * delta
		# Limit motion speed
		y_motion = clamp(y_motion, -MOTION_LIMIT, MOTION_LIMIT)
		position.y += y_motion
		
		# Check if it touches the top
		if position.y < $Sprite.texture.get_height() / 2:
			y_motion = 0
			position.y = $Sprite.texture.get_height() / 2
		
		# Check if it touches the ground
		if position.y > GROUND_Y - $Sprite.texture.get_height() / 2:
			y_motion = 0
			position.y = GROUND_Y - $Sprite.texture.get_height() / 2


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("flap"):
		flap()
	
	if event is InputEventScreenTouch:
		if event.pressed:
			flap()


func _on_Player_area_entered(area: Area2D) -> void:
	if area.is_in_group("Obstacle") and can_die:
		if Global.main:
			Global.main.can_retry = true
		
		Global.current_speed = 0
		queue_free()


func flap() -> void:
	if not can_move: can_move = true
	y_motion = -FLAP_FORCE
