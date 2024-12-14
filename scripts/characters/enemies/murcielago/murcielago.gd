extends CharacterBody2D

const SPEED = 200.0
const CLOSE_RANGE_X = 30  # Rango cercano en X
const CLOSE_RANGE_Y = 60  # Rango cercano en Y
const ATTACK_RANGE = 200  # Rango de ataque adicional

var is_dead = false
var is_area_player = false
var was_attack = false

@onready var anim = $AnimatedSprite2D
@onready var player_camera = get_parent().get_parent().get_node("Player/player1/Camera2D")
@onready var player = get_parent().get_parent().get_node("Player/player1")

var left_limit = 0
var right_limit = 0
var direction = Vector2(1, 0)

func _ready():
	update_limits()
	
func _physics_process(delta):
	if is_dead:
		return
	anim.play("fly")
	if is_area_player:
		handle_player_interaction()
	## si la altura del murcielago es mas que 
	elif round(position.y) <= round(player.position.y-250):
		position.y += 5
	else:
		move_enemy(delta)
		update_limits()


func handle_player_interaction():
	anim.speed_scale = 2
	# Calcular dirección hacia el jugador
	var direction_to_player = (player.position - position).normalized()
	anim.rotation = direction_to_player.angle() - 2
		
	var player_pos = Vector2(round(player.position.x), round(player.position.y))
	var bat_pos = Vector2(round(position.x), round(position.y))

	#if distance_x < CLOSE_RANGE_X and distance_y < CLOSE_RANGE_Y:
		#return
		
	# Determinar comportamiento dependiendo del rango
	if in_close_range(bat_pos, player_pos):
		was_attack = true

	if was_attack and in_attack_range(bat_pos, player_pos):
		move_towards(Vector2(5, -5))
	else:
		was_attack = false
		move_towards_player(player_pos, bat_pos)
	

func in_close_range(bat_pos, player_pos):
	return bat_pos.x <= (player_pos.x + CLOSE_RANGE_X) and bat_pos.y >= (player_pos.y - CLOSE_RANGE_Y)

func in_attack_range(bat_pos, player_pos):
	return bat_pos.x <= (player_pos.x + ATTACK_RANGE) and bat_pos.y <= (player_pos.y + ATTACK_RANGE)

func move_towards(offset):
	position += offset

func move_towards_player(player_pos, bat_pos):
	if bat_pos.x <= (player_pos.x + CLOSE_RANGE_X):
		position.x += 2
	elif bat_pos.x >= (player_pos.x + CLOSE_RANGE_X):
		position.x -= 2

	if bat_pos.y >= (player_pos.y - CLOSE_RANGE_Y):
		position.y -= 2
	elif bat_pos.y <= (player_pos.y - CLOSE_RANGE_Y):
		position.y += 2
			
func update_limits():
	var half_window_width = (get_viewport_rect().size.x/2) * player_camera.zoom.x
	left_limit = player_camera.get_screen_center_position().x - half_window_width
	right_limit = player_camera.get_screen_center_position().x + half_window_width
	
func move_enemy(delta):
	anim.speed_scale = 0.5
	position += direction * SPEED * delta
	if position.x < left_limit:
		change_direction(Vector2(1, 0), true)
	elif position.x > right_limit:
		change_direction(Vector2(-1, 0), false)

func change_direction(new_direction, flip_h):
	direction = new_direction
	anim.flip_h = flip_h
	
func _on_animated_sprite_2d_animation_finished():
	if is_dead && anim.animation == "Death":
		queue_free()		
		return

func _on_area_ataque_body_entered(body):
	if body.name == "player1":
		is_area_player = true


func _on_area_ataque_body_exited(body):
	if body.name == "player1":
		is_area_player = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("Sword"):
		is_dead = true
		anim.play("Death")
		velocity.x = 0
