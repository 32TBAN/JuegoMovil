extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D
@onready var player = get_parent().get_parent().get_node("Player/player1")

func _physics_process(delta):
	anim.play("walk")
	move(delta)

func move(delta):
	var distance = position.distance_to(player.position)
	if distance <= 400:
		var direction_to_player = (player.position - position).normalized()
		if direction_to_player.x >= 0.60:
			position.x += 2
			anim.flip_h = false 
		else:
			position.x -= 2
			anim.flip_h = true		
		#print(direction_to_player)
		#print(distance)
	#print(distance)
	if not is_on_floor():
		velocity.y += gravity * delta 
	move_and_slide()
