extends Sprite

signal waveCover
signal waveAfter
export (float) var speed = 800

var emited = false
func _ready():
	set_process(true)

func _process(delta):
	position.x = position.x - speed*delta;
	if position.x  < -200 && ! emited:
		emit_signal("waveCover")
		emited = true
	if position.x  < -500:
		emit_signal("waveAfter")
		queue_free()
	
