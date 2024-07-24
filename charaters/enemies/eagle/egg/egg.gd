extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	get_node("AnimatedSprite2D").play("break")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "break":
		queue_free()
