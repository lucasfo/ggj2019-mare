extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$mat1.visible = false
	$mat1.set_process(false)
	$mat2.visible = false
	$mat2.set_process(false)
	$mat3.visible = false
	$mat3.set_process(false)
	pass

func put(index):
	$mat1.visible = false
	$mat2.visible = false
	$mat3.visible = false
	
	if index == 1:
		$mat1.visible = true;
	elif index == 2:
		$mat2.visible = true;
	elif index == 3:
		$mat3.visible = true;
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
