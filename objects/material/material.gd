extends Node2D

# Use between 1 and 2
export (int) var type = 1
var mat = ["res://sprites/material1.png", "res://sprites/material2.png"]

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

#func _ready():
#	_update_material()
#	pass

func _update_material():
	var spr = get_child(0)
	spr.texture = load(mat[type - 1])

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	timelapse += delta
	if timelapse > animSpeed:
		timelapse = 0
		animFrame = (animFrame +1) % 6
		updateFrame()
#	pass

func updateFrame():
	$Sprite.frame = animFrame
	
	