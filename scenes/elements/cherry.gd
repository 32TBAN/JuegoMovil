extends Area2D

@onready var game_manager = $"../../../GameManager"

func _on_body_entered(body):
	if body.name == "player1":
		queue_free()
		game_manager.add_points()
