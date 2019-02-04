extends Sprite

# Use between 1 and 2

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
		animFrame = (animFrame +1) % 4
		updateFrame()
#	pass

func updateFrame():
	self.frame = animFrame
	
	