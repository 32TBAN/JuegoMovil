extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var attack_area = $Area2DAttack
var is_attacking = false

func _process(delta):
	if !is_attacking:
		handle_input()
	handle_gravity(delta) # Apply gravity even when attacking

	move_and_slide()

	if Input.is_action_just_pressed("attack") and not is_attacking:
		anim.play("MeleAttack")
		is_attacking = true
		get_node("Area2DAttack/CollisionShape2DAttack").disabled = false

func handle_input():
	velocity.x = 0
	
	if Input.is_action_pressed("rigth"):
		anim.flip_h = false
		velocity.x = SPEED
		attack_area.position.x = 0
		$CollisionShape2DPlayer.position.x = 0		
		
	elif Input.is_action_pressed("left"):
		anim.flip_h = true
		velocity.x = -SPEED
		$CollisionShape2DPlayer.position.x = 43
		attack_area.position.x = -34  # Cambiar la posición del área de ataque
		
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
		
		# Después de atacar, verificar la entrada y actualizar la animación
		if velocity.x != 0:
			anim.play("Run")
		else:
			anim.play("Idle")
