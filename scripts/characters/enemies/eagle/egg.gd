extends RigidBody2D

@onready var game_manager =  $"../../../../GameManager"

func _on_area_2d_body_entered(body):
	if body.name == "player1":
		var x_delta = position.x - body.position.x
		if x_delta < 2.6:
			game_manager.decrease_health()	
	get_node("AnimatedSprite2D").play("break")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "break":
		queue_free()
