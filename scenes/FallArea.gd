extends Area2D

func _on_body_entered(body):
	if body.name == "player1":
		get_tree().reload_current_scene()
