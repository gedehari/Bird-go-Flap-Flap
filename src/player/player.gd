extends Area2D
signal dead

const GRAVITY = 75
const MOTION_LIMIT = 50
const GROUND_Y = 1125

const FLAP_FORCE = 22

var can_move = false

var y_motion: float = 0
var on_ground: bool = true

var can_die: bool = true
var is_dead: bool = false


func _ready() -> void:
	if not Global.first_game:
		can_move = true
		flap(true)
	
	Global.player_x = position.x


func _process(delta: float) -> void:
	$Sprite.rotation_degrees = y_motion * 0.6


func _physics_process(delta: float) -> void:
	if can_move:
		y_motion += GRAVITY * delta
		# Limit motion speed
		y_motion = clamp(y_motion, -MOTION_LIMIT, MOTION_LIMIT)
		position.y += y_motion
		
		if not is_dead:
			# Check if it touches the top
			if position.y < $Sprite.texture.get_height() / 2:
				y_motion = 0
				position.y = $Sprite.texture.get_height() / 2
			
			# Check if it touches the ground
			if position.y > GROUND_Y - $Sprite.texture.get_height() / 2:
				call_deferred("die")
	if is_dead:
		position.x -= Global.current_speed * delta


func _input(event: InputEvent) -> void:
	if not is_dead:
		if Input.is_action_just_pressed("flap"):
			flap(true)
		
		if event is InputEventScreenTouch:
			if event.pressed:
				flap(true)


func _on_Player_area_entered(area: Area2D) -> void:
	if area.is_in_group("Obstacle") and can_die and not is_dead:
		call_deferred("die")


func die() -> void:
	is_dead = true
	flap(false)
	
	if Global.main:
		connect("dead", Global.main, "_on_player_dead")
		emit_signal("dead")


func flap(play: bool) -> void:
	if not can_move: can_move = true
	y_motion = -FLAP_FORCE
	
	if play: $FlapSound.play()
	else:
		$HitSound.play()
		$DieSound.play()
