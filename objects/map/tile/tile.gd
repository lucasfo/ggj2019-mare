extends Area2D

enum EBORDER {
	CENTER,
	DIAGONAL,
	WATER,
	N,
	E,
	S,
	W,
	NW,
	NE,
	SW,
	SE
}

enum ECOLOR {
	WHITE,
	GRAY,
	BLACK
}

enum EDIR {
	NONE,
	UP,
	RIGHT,
	DOWN,
	LEFT
}

enum ECONT {
	NONE,
	MAT,
	WALL,
	WATER
}

signal tileClicked

var animFrame = 0
export (EBORDER) var border = EBORDER.CENTER
export (bool) var isFree = true;
export (EBORDER) var color = ECOLOR.WHITE
export (EDIR) var parent = EDIR.NONE
export (ECONT) var contType = ECONT.NONE
export (Vector2) var indexes = Vector2(-1, -1)
export (float) var matChance = 0.6
export (PackedScene) var Mat1
export (PackedScene) var Mat2
export (PackedScene) var Mat3
export (bool) var buildable = false;
export (EDIR) var side = EDIR.NONE
export (PackedScene) var Wall1;
export (PackedScene) var Wall2;
export (PackedScene) var Wall3;
 

var animation = [
	[28] # Center
	, [19] # Diagonal
	, [0] # Water
	, [1, 6, 11, 16, 2, 7, 12, 17, 3, 8, 13, 18] # N
	, [24, 29, 34, 39, 44, 49, 54, 59, 64, 69, 74, 79] # E
	, [81, 86, 91, 96, 82, 87, 92, 97, 83, 88, 93, 98] # S
	, [20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75] # W
	, [0, 5, 10, 15] # NW
	, [4, 9, 14, 19] # NE
	, [80, 85, 90, 95] # SW
	, [84, 89, 94, 99] # SE
]

export (float) var animSpeed = 1
var timelapse = 0


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	contType = ECONT.NONE
	updateFrame()
	timelapse = 0
	set_process(true)
	randomize()
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	timelapse += delta
	if timelapse > animSpeed:
		timelapse = 0
		animFrame = (animFrame +1) % animation[border].size()
		updateFrame()
#	pass

func setBorder(b):
	animFrame = randi()%15
	if b == EBORDER.W || b == EBORDER.SW \
		|| b == EBORDER.SE || b == EBORDER.S \
		|| b == EBORDER.NW || b == EBORDER.NE \
		|| b == EBORDER.N  || b == EBORDER.E:
		$Sprite.texture = load("res://objects/map/tile/tileset_animado_4.png")
		$Sprite.vframes = 5
		$Sprite.hframes = 20
	else:
		$Sprite.texture = load("res://objects/map/tile/tile_praia.png")
		$Sprite.vframes = 8
		$Sprite.hframes = 8
	border = b
	animFrame = (animFrame +1) % animation[border].size()
	updateFrame()
	
func updateFrame():
	$Sprite.frame = animation[border][animFrame]

func content():
	if contType != ECONT.NONE:
		isFree = true
		contType = ECONT.NONE
		var cont = get_node("content")
		remove_child(cont)
		return cont
	else:
		return null;

func setContent(content, type):
	isFree = false
	content.name = "content"
	add_child(content)
	contType = type

func upgrade(material):
	if get_node("content").type == material:
		return get_node("content")._increase_life(1)
	return false

func loseMaterial():
	isFree = true
	contType = ECONT.NONE
	var cont = get_node("content")
	remove_child(cont)
	cont.queue_free()

func loseLife():
	var cont = get_node("content")
	cont._decrease_life(1)
	if cont.dead():
		remove_child(cont)
		cont.queue_free()
		contType = ECONT.NONE
		isFree = true
	
func _input_event(viewport, event, shape_idx):
	 if event is InputEventMouseButton \
	 		and event.button_index == BUTTON_LEFT \
	 		and event.is_pressed():
	 	self.on_click()

func initMap(v):
	position = Vector2(v.y*16, v.x*16)
	indexes = v

func on_click():
	emit_signal("tileClicked",indexes, contType)

func setHouse():
	isFree = false
	contType = ECONT.WALL

func setWater():
	isFree = false
	contType = ECONT.WATER
	
func build(material):
	isFree = false
	contType = ECONT.WALL
	var content
	if material == 1:
		content = Wall1.instance()
	elif material == 2:
		content = Wall2.instance()
	elif material == 3:
		content = Wall3.instance()
	else:
		return false
	content.name = "content"
	content.z_index=0
	add_child(content)
	return true


func genMaterial():
	var rand = randi()%100
	var randType = (randi()%3) +1
	if rand < matChance*100 and isFree and !buildable:
		isFree = false
		contType = ECONT.MAT
		var content
		if randType == 1:
			content = Mat1.instance()
		elif randType == 2:
			content = Mat2.instance()
		elif randType == 3:
			content = Mat3.instance()
		content.name = "content"
		content.z_index=0
		add_child(content)

func makeBuildable(s):
	buildable = true;
	side = s