extends CharacterBody2D

const SPEED = 200.0

var is_dead = false
@onready var anim = $AnimatedSprite2D
var direction = Vector2(1, 0)
@onready var player_camera = get_parent().get_parent().get_node("Player/player1/Camera2D")
@onready var player = get_parent().get_parent().get_node("Player/player1")

var left_limit = 0
var right_limit = 0

var is_area_player = false

func _ready():
	
	update_limits()
	
func _physics_process(delta):
	if is_dead:
		return
	if is_area_player:
		velocity.x = 0
		var direction_to_player = (player.position - position).normalized()
		$AnimatedSprite2D.rotation = direction_to_player.angle()
		#print(direction_to_player.x)
		#print(position.x)
		
		if position.x > 0:
			position.x -= 1
		else:
			position.x += 1
		#if position != direction_to_player:
			#while position.x != position.x:
				#position.x += 100
				#
		#print("Dirección al jugador:", direction_to_player)
		#print("Posición del murciélago:", position)
	else:
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
		anim.flip_h = true		
	elif position.x > right_limit:
		direction = Vector2(-1, 0) # Mueve a la izquierd
		anim.flip_h = false
		
	anim.play("fly")
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("Sword"):
		is_dead = true
		anim.play("Death")
		velocity.x = 0


func _on_animated_sprite_2d_animation_finished():
	if is_dead && anim.animation == "Death":
		queue_free()		
		return

func _on_area_ataque_body_entered(body):
	if body.name == "player1":
		is_area_player = true
		#var direction_to_player = (player.position - position)
		#if position != direction_to_player:
			#while position.x != position.x:
				#position.x += 100
				#
		#$AnimatedSprite2D.rotation = direction_to_player.angle()
		#print("Dirección al jugador:", direction_to_player)
		#print("Posición del murciélago:", position)
