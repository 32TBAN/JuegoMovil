extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -410.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var attack_area = $Area2DAttack
var is_attacking = false
var arrow_scene = preload("res://charaters/players/arrow.tscn")

func _process(delta):
	if !is_attacking:
		handle_input()
	handle_gravity(delta) # Apply gravity even when attacking

	move_and_slide()
	
	if  Input.is_action_pressed("jump") and Input.is_action_pressed("attack"):
		anim.play("AttackJump")
		is_attacking = true
		get_node("Area2DAttack/CollisionShape2DAttack").disabled = false
		
	if Input.is_action_just_pressed("attack") and not is_attacking:
		anim.play("MeleAttack")
		is_attacking = true
		get_node("Area2DAttack/CollisionShape2DAttack").disabled = false

	if Input.is_action_just_pressed("attack2") and not is_attacking:
		anim.play("RangeAttack")
		is_attacking = true
		anim.flip_h = !anim.flip_h
		shoot_arrow()
		

		
func handle_input():
	velocity.x = 0
	
	if Input.is_action_pressed("rigth"):
		anim.flip_h = false
		velocity.x = SPEED
		attack_area.position.x = 0
		$CollisionShape2DPlayer.position.x = -2
		anim.position.x = 0
		attack_area.position.x = 10
		
	elif Input.is_action_pressed("left"):
		anim.flip_h = true
		velocity.x = -SPEED
		attack_area.position.x = -82  # Cambiar la posición del área de ataque
		
		$CollisionShape2DPlayer.position.x = -25	
		anim.position.x = -30
		
	if velocity.x != 0 && !is_attacking:
		if is_on_floor():
			anim.play("Run")
	elif is_on_floor() && !is_attacking:
		anim.play("Idle")
		
	if Input.is_action_just_pressed("jump") and is_on_floor() && !is_attacking:
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "MeleAttack":
		is_attacking = false
		get_node("Area2DAttack/CollisionShape2DAttack").disabled = true
	elif anim.animation == "RangeAttack":
		anim.position.y = $CollisionShape2DPlayer.position.y	
		is_attacking = false
		anim.flip_h = !anim.flip_h
	
	if anim.animation == "AttackJump":
		is_attacking = false
		get_node("Area2DAttack/CollisionShape2DAttack").disabled = true
			
	if velocity.x != 0:
		anim.play("Run")
	else:
		anim.play("Idle")

func shoot_arrow():
	var arrow = arrow_scene.instantiate()
	var direction = false
	if !anim.flip_h:
		direction = Vector2.LEFT
		arrow.get_node("Arrow").flip_h = true
	else:
		direction = Vector2.RIGHT
				
	arrow.direction = direction
	if direction.x == -1:
		arrow.position = global_position + Vector2(direction.x * 50, -40)	
		arrow.get_node("Area2D/CollisionShape2D").position.x = direction.x
	else:
		arrow.position = global_position + Vector2(direction.x * 20, -40)
	get_parent().add_child(arrow)
