extends Node2D

var moveUp = true
#var count = 0
#var inc = 1

func _ready():
	#set_process(true)
	pass

#func _process(delta):
#	if moveUp:
#		$num.position.y += inc*0.5
#	else:
#		$num.position.x += inc*0.5
#	count += 0.5
#	if count > 4:
#		inc *= -1
#		count = 0
#	
func makeVisible(i, index):
	$num.frame = index -1
	$num.visible = false
	$up.visible = false
	$right.visible = false
	$down.visible = false
	$left.visible = false
	#$num.position = Vector2(0, 0)
	if i == 1:
		$up.visible = true
		$num.visible = true
		#moveUp = true
	elif i == 2:
		$right.visible = true
		$num.visible = true
		#moveUp = false
	elif i == 3:
		$down.visible = true
		$num.visible = true
		#moveUp = true
	elif i == 4:
		$left.visible = true
		$num.visible = true
		#moveUp = false
