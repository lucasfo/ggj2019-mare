extends Sprite

var id=0
var animFrame = 0
var timelapse = 0
export (float) var animSpeed = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	updateFrame()
	timelapse = 0
	set_process(true)
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	timelapse += delta
	if timelapse > animSpeed:
		timelapse = 0
		if animFrame +1 == 8:
			self.queue_free()
			return
		animFrame = (animFrame +1) % 8
		updateFrame()
#	pass

func updateFrame():
	self.frame = animFrame
	
	