extends RigidBody2D

var speed = 500
var direction = Vector2.ZERO
@onready var disappear_timer = $Timer

func _ready():
	gravity_scale = 0 

func _integrate_forces(state):
	if direction != Vector2.ZERO:
		linear_velocity = direction * speed

func _on_area_2d_area_entered(area):
	gravity_scale = 1 # Activa la gravedad al colisionar
	direction = Vector2.ZERO  # Detiene el movimiento lineal
	linear_velocity = Vector2.ZERO  # Resetear velocidad
	disappear_timer.start(1)

func _on_timer_timeout():
	queue_free()
