extends Node

var points = 0
var lives = 3
@onready var points_label = %pointsLabel
@export var hearts : Array[Node]

@export var bat_scene = preload("res://charaters/enemies/murcielago/murcielago.tscn")
@export var spawn_position: Vector2 = Vector2(0, 0)
var is_enemy_spawned = false
@onready var player = get_node("../SceneObjects/Player/player1")
#func _ready():
	#print(get_tree().root.get_child(0).name)

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


func _on_area_2d_body_entered(body):
	if body.name == "player1" and not is_enemy_spawned:
		spawn_enemy()
		is_enemy_spawned = true #Para controlar que solo spawne 1 m

func spawn_enemy():
	if bat_scene:
		var bat_instance = bat_scene.instantiate()
		bat_instance.position = Vector2((player.position.x+900), (player.position.y-500))
		var mods_node = get_node("../SceneObjects/Mods")
		mods_node.add_child(bat_instance)
