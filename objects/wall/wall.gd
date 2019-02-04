extends Node2D

# Use 1, 2 or 3
export (int) var lives = 1
# Use 1 or 2
export (int)var type = 1

var animFrame = 0
var timelapse = 0
export (float) var animSpeed = 1

func _ready():
	updateFrame()
	animate()
	#_update_box()
	pass

func _decrease_life(num_lives):
	if lives > 0:
		lives = lives - num_lives
		updateFrame()

func _increase_life(num_lives):
	if lives < 3:
		lives = lives + num_lives
		updateFrame()
		animate()
		return true
	return false

func animate():
	animFrame = 0
	timelapse = 0
	set_process(true)


func _process(delta):
	timelapse += delta
	if timelapse > animSpeed:
		timelapse = 0
		if animFrame == 1 :
			set_process(false)
		animFrame = (animFrame +1) % 3
		updateFrame()
#	if Input.is_action_just_pressed("ui_left"):
#		_decrease_life(1)
#	elif Input.is_action_just_pressed("ui_right"):
#		_increase_life(1)

func updateFrame():
	if lives > 0:
		$Sprite.frame = (lives -1)*3 + animFrame

func dead():
	return lives < 1