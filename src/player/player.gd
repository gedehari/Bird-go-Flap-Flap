extends Area2D

const GRAVITY = 75
const MOTION_LIMIT = 50
const GROUND_Y = 1280

const FLAP_FORCE = 22

var y_motion: float = 0
var on_ground: bool = true

var can_die: bool = true


func _ready() -> void:
	Global.player_x = position.x


func _process(delta: float) -> void:
	$Sprite.rotation_degrees = y_motion * 0.6


func _physics_process(delta: float) -> void:
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


func _on_Player_area_entered(area: Area2D) -> void:
	if area.is_in_group("Obstacle") and can_die:
		Global.current_speed = 0
		queue_free()


func flap() -> void:
	y_motion = -FLAP_FORCE
