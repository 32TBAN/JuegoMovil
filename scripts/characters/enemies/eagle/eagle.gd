extends CharacterBody2D

const SPEED = 200.0

@onready var anim = $AnimatedSprite2D
var direction = Vector2(1, 0)
@onready var player_camera = get_parent().get_parent().get_parent().get_node("Player/player1/Camera2D")
@onready var player = get_parent().get_parent().get_parent().get_node("Player/player1")

var left_limit = 0
var right_limit = 0

var egg_scene = preload("res://charaters/enemies/eagle/egg.tscn")
var can_drop_egg = true
@onready var egg_timer = $egg_timer
var is_dead = false

func _ready():
	update_limits()

func _physics_process(delta):
	if is_dead:
		return
	move_enemy(delta)
	update_limits()
	drop_egg_if_above_player()
	
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
		
func drop_egg_if_above_player():
	# Verificar si el enemigo está cerca de la posición del jugador en el eje X
	if abs(position.x - player.position.x) < 10 and can_drop_egg:
		# Crear y agregar el huevo a la escena
		var egg = egg_scene.instantiate()
		egg.position = position + Vector2(0, 20) # Ajustar la posición del huevo si es necesario
		get_parent().add_child(egg)		
		can_drop_egg = false
		egg_timer.start(1)


func _on_egg_timer_timeout():
	can_drop_egg = true # Replace with function body.


func _on_area_2d_area_entered(area):
	if area.is_in_group("Sword"):
		is_dead = true
		anim.play("Death")
		velocity.x = 0
	elif area.is_in_group("ArrowDamage"):
		is_dead = true
		anim.play("Death")
		velocity.x = 0

func _on_animated_sprite_2d_animation_finished():
	if is_dead && anim.animation == "Death":
		queue_free()		
		return
