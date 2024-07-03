extends ParallaxBackground

var scrolling_speed = 100 # velocidad de desplazamiento
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# delta es el tiempo transcurrido desde ultimo frame
func _process(delta): 
	scroll_offset.x -= scrolling_speed * delta #
