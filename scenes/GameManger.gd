extends Node

var points = 0
var lives = 3
@onready var points_label = %pointsLabel
@export var hearts : Array[Node]

func decrease_health():
	lives -= 1
	for h in 3:
		if h < lives:
			hearts[h].show()
		else:
			hearts[h].hide()
	if lives == 0:
		get_tree().reload_current_scene()
		lives = 3

func add_points():
	points += 1
	points_label.text = "Points: " + str(points)
