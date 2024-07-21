class_name Arrow
extends Node2D

@export var speed = 1000.0
@export var lifetime = 3.0

var direction = Vector2.ZERO

@onready var timer = $Timer 
@onready var hitbox = $HitBox
@onready var sprinte = $Sprite
@onready var impact_detector = $ImpactDetector

# Called when the node enters the scene tree for the first time.
func _ready():
#	set_as_toplevel(true)
	look_at(position + direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
