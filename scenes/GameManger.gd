extends Node

var points = 0
@onready var points_label = %pointsLabel

func add_points():
	points += 1
	points_label.text = "Points: " + str(points)
