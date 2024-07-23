extends CharacterBody2D

const SPEED = 200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D
var direction = Vector2(1, 0)
@onready var player_camera = get_parent().get_node("Player/player1/Camera2D")
@onready var player = get_parent().get_node("Player")

var left_limit = 0
var right_limit = 0

func _ready():
	update_limits()

func _physics_process(delta):
	move_enemy(delta)
	update_limits()
	
func update_limits():
	var half_window_width = (get_viewport_rect().size.x/2) * player_camera.zoom.x

	left_limit = player_camera.get_screen_center_position().x - half_window_width
	right_limit = player_camera.get_screen_center_position().x + half_window_width
	
func move_enemy(delta):
	position += direction * SPEED * delta

	if position.x < left_limit:
		direction = Vector2(1, 0) # Mueve a la derecha
		anim.flip_h = !anim.flip_h		
	elif position.x > right_limit:
		direction = Vector2(-1, 0) # Mueve a la izquierd
		anim.flip_h = !anim.flip_h	
	anim.play("fly")
		

