extends CharacterBody2D

var SPEED = 30.0
const JUMP_VELOCITY = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D
var is_idle = true
var is_dead = false

func _ready():
	pass

func _physics_process(delta):
	if is_dead:
		return
	
	if !is_idle:
		handle_input()		
	handle_gravity(delta)
	
	if is_idle:
		anim.play("Idle")
		is_idle = true
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision.get_collider())
				
	move_and_slide()

func handle_input():
	if is_on_floor() && !is_dead:
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		is_idle = false
	
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta 

func handle_collision(collider):
	if collider.name == "TileMap3":
		return
		
	velocity.x = -velocity.x
	anim.flip_h = not anim.flip_h
	SPEED = SPEED * -1
	

func _on_animated_sprite_2d_animation_finished():
	if is_dead:
		queue_free()		
		return
		
	if anim.animation == "Idle" && !is_dead:
		is_idle = false
		anim.play("Jump")
		velocity.x = -SPEED
	elif anim.animation == "Jump" && !is_dead:
		is_idle = true
		anim.play("Idle")
		velocity.x = 0
		

func _on_area_2d_area_entered(area):
	if area.is_in_group("Sword"):
		is_dead = true
		anim.play("Death")
		velocity.x = 0
	elif area.is_in_group("ArrowDamage"):
		is_dead = true
		anim.play("Death")
		velocity.x = 0
	
