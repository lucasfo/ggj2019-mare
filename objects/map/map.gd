extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

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
	WALL
}

var ground
export (int) var width = 10
export (int) var height = 10
export (PackedScene) var Tile;
export (PackedScene) var Pop
var houseLife = 5


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	ground = []
	ground.resize(width)
	for i in range(0, width):
		ground[i] = []
		ground[i].resize(height)
		for j in range (0, height):
			ground[i][j] = Tile.instance()
			ground[i][j].initMap(Vector2(i, j))
			ground[i][j].setBorder(EBORDER.DIAGONAL)
			add_child(ground[i][j])

	
	for i in range(0, 4):
		for j in range (0, 4):
			ground[i+(width/2)-2][j+(height/2)-2].setHouse()
			
	# CREATE BUILDABLE AREA HARDCODES TO 14 (12+2) TILES

	# NORTH
	for i in range(0, 4):
		for j in range (0, 4):
			ground[i+1][j+5].makeBuildable(EDIR.UP)
			ground[i+1][j+5].setBorder(EBORDER.CENTER)
	
	# EAST
	for i in range(0, 4):
		for j in range (0, 4):
			ground[i+5][j+9].makeBuildable(EDIR.RIGHT)
			ground[i+5][j+9].setBorder(EBORDER.CENTER)
	
	# SOUTH
	for i in range(0, 4):
		for j in range (0, 4):
			ground[i+9][j+5].makeBuildable(EDIR.DOWN)
			ground[i+9][j+5].setBorder(EBORDER.CENTER)
	
	# WEST
	for i in range(0, 4):
		for j in range (0, 4):
			ground[i+5][j+1].makeBuildable(EDIR.LEFT)
			ground[i+5][j+1].setBorder(EBORDER.CENTER)

	# CREATE SHORE
	for i in range(0, height):
		ground[0][i].setBorder(EBORDER.WATER)
		ground[0][i].setWater()
		ground[1][i].setBorder(EBORDER.N)
		ground[width -1][i].setBorder(EBORDER.WATER)
		ground[width -1][i].setWater()
		ground[width -2][i].setBorder(EBORDER.S)
		
	for i in range(1, width-1):
		ground[i][0].setBorder(EBORDER.WATER)
		ground[i][0].setWater()
		ground[i][1].setBorder(EBORDER.W)
		ground[i][height -1].setBorder(EBORDER.WATER)
		ground[i][height -1].setWater()
		ground[i][height -2].setBorder(EBORDER.E)
	
	ground[1][1].setBorder(EBORDER.NW)
	ground[1][height-2].setBorder(EBORDER.NE)
	ground[width -2][1].setBorder(EBORDER.SW)
	ground[width -2][height-2].setBorder(EBORDER.SE)
			
	var home = $home
	remove_child($home)
	add_child(home)
	$home.position = Vector2(((height/4)-2)*16, ((width/4)-2)*16)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func move(source, target):
	#Clean
	var iSt = source.x
	var jSt = source.y
	var iTarg = target.x
	var jTarg = target.y
	var targetFree = ground[iTarg][jTarg].isFree
	ground[iTarg][jTarg].isFree = true
	for i in range(0, width):
			for j in range (0, height):
				ground[i][j].color = ECOLOR.WHITE
				ground[i][j].parent = EDIR.NONE

	#BFS
	var queue = [Vector2(iSt,jSt)]
	var found = false
	
	while !queue.empty():
		var item = queue.front()
		queue.pop_front()
		ground[item.x][item.y].color = ECOLOR.BLACK

		if item.x == iTarg and item.y == jTarg:
			found = true
			break; 

		if item.x > 0:
			var tile = ground[item.x -1][item.y]
			if tile.color == ECOLOR.WHITE and tile.isFree:
				queue.append(Vector2(item.x -1, item.y))
				tile.parent = EDIR.RIGHT
				tile.color = ECOLOR.GRAY

		if item.x < width -1:
			var tile = ground[item.x +1][item.y]
			if tile.color == ECOLOR.WHITE and tile.isFree:
				queue.append(Vector2(item.x +1, item.y))
				tile.parent = EDIR.LEFT
				tile.color = ECOLOR.GRAY
				
		if item.y > 0:
			var tile = ground[item.x][item.y -1]
			if tile.color == ECOLOR.WHITE and tile.isFree:
				queue.append(Vector2(item.x, item.y -1))
				tile.parent = EDIR.DOWN
				tile.color = ECOLOR.GRAY

		if item.y < height -1:
			var tile = ground[item.x][item.y +1]
			if tile.color == ECOLOR.WHITE and tile.isFree:
				queue.append(Vector2(item.x, item.y +1))
				tile.parent = EDIR.UP
				tile.color = ECOLOR.GRAY
	
	ground[iTarg][jTarg].isFree = targetFree
	if !found:
		return []
	
	queue = []
	var tile = ground[iTarg][jTarg]
	var i = iTarg
	var j = jTarg
	while tile.parent != EDIR.NONE:
		if tile.parent == EDIR.UP:
			j -= 1
		elif tile.parent == EDIR.DOWN:
			j += 1
		elif tile.parent == EDIR.LEFT:
			i -= 1
		elif tile.parent == EDIR.RIGHT:
			i += 1

		queue.push_front(Vector2(i, j))
		tile = ground[i][j]
	
	return queue
	 

func collect(v):
	var i = v.x
	var j = v.y
	if ground[i][j].contType == ECONT.MAT:
		var aux = ground[i][j].content()
		var ret = aux.type
		if aux.type >0 && aux.type<4:
			ground[i][j].add_child(Pop.instance())
		ground[i][j].isFree = true
		aux.queue_free()
		return ret
	else:
		return null
	pass

func drop(content, i, j):
	ground[i][j].contType == ECONT.MAT
	ground[i][j].setContent(content)

func exchange(content, i, j):
	if ground[i][j].contType == ECONT.MAT:
		var ret = ground[i][j].content()
		ground[i][j].setContent(content, ECONT.MAT)
		return ret
	else:
		return content
	pass
	

func build(v, material):
	if material==null || material <1:
		return false
	var i = v.x
	var j = v.y
	var tile = ground[i][j]
	if tile.isFree and tile.buildable:
		return tile.build(material)
		
	elif tile.buildable:
		return tile.upgrade(material)
	
	return false
	pass
	
func setBusy(v):
	ground[v.x][v.y].isFree = false
	pass

func setFree(v):
	ground[v.x][v.y].isFree = true
	pass

func wave(dir,strength):
	var counter=strength
	for i in range(1, width-1):
			for j in range (1, height-1):
				var tile = ground[i][j]
				if !tile.isFree:
					if tile.contType == ECONT.MAT:
						tile.loseMaterial()
					elif tile.contType == ECONT.WALL and tile.side == dir:
						tile.loseLife()
						counter -= 1
	setupMaterials()
	if counter > 0:
		houseLife = houseLife - counter
		if 4-houseLife < 0:
			$home.frame = 0
		elif 4-houseLife > 4:
			$home.frame=4
		else:
			$home.frame = 4 - houseLife
	if houseLife < 0:
		$home.visible = false
	return houseLife>-1

func setupMaterials():
	for i in range(0, width):
			for j in range (0, height):
				ground[i][j].genMaterial()

func listener(node):
	for i in range(0, width):
			for j in range (0, height):
				ground[i][j].connect("tileClicked", node, "detectTouch")
