extends Node2D

enum ECONT {
	NONE,
	MAT,
	WALL,
	WATER
}


var lastAction = ECONT.NONE
var targetAction = Vector2(-1, -1)
export (Vector2) var offset = Vector2(0,0)
export (PackedScene) var Wave

var timelapse = 0
var nextTime = 0
var minTime = 0
export (PackedScene) var Leaderboard
var score =0
var nextWaveSide = 1
var nextWaveStr = 1
var dead =false
var duringWave = false # true = wave is hapenning

# Balance params
var waveSideProb = [
	100
	, 0
]
var waveMinTime = 1
var waveMaxTime = 10

var waveStrProb = [
	20
	, 20
	, 20
	, 20
	, 20
]

var waveMinStr = 1
var waveMaxStr = 9

func _ready():
	position = position + offset
	randomize()
	score=0
	$map.listener(self)
	var playerInit = Vector2(10, 8)
	$Player.setpos(playerInit)
	$map.setBusy(playerInit)
	#$map.setupMaterials()
	$map.setFree(playerInit)
	$Player.connect("endMoviment", self, "doAction")
	nextTime = 0
	set_process(true)
	duringWave = false
	nextWaveSide = 1
	nextWaveStr = 1
	initBalance()

func _process(delta):
	timelapse += delta
	if timelapse > nextTime and !dead:
		var wave = Wave.instance()
		wave.position.x = 224
		add_child(wave)
		wave.connect("waveCover", self, "onWave")
		wave.connect("waveAfter", self, "afterWave")
		set_process(false)
		$Player.setMove([])
		lastAction = ECONT.NONE
		#$Player.set_process(false)
		$map.set_process(false)
		duringWave = true
		
	# Down wave
	var perc = timelapse/waveMaxTime
	$waveHud.position.y = perc*192 + (waveMaxTime - nextTime)*16

func onWave():

	if !$map.wave(nextWaveSide, nextWaveStr) && !dead:
		dead=true
		set_process(false)
		var lb = Leaderboard.instance()
		lb.rect_scale = Vector2(0.5,0.5)
		lb.rect_position = Vector2(-16,0)
		lb.receiveScore(score)
		self.add_child(lb)
		$map.set_process(false)
		$Player.set_process(false)
		return
	setBallon(nextWaveSide, false, nextWaveStr)
	hardUp()
	prepareNextWave()
	
	score= score+1
	$scoreLabel.set_text("Score: " + str(score))
	
func afterWave():
	set_process(true)
	$Player.set_process(true)
	$map.set_process(true)
	setBallon(nextWaveSide, true, nextWaveStr)
	duringWave = false

func spawnWave():
	var direction = (randi()%5)+1
	score +=1
	emit_signal("waveSpawned",direction)

func detectTouch(indexes, contType):
	if !duringWave:
		lastAction = contType
		targetAction = indexes;
		$Player.setMove($map.move($Player.gridPos,indexes))

func doAction():
	if lastAction == ECONT.MAT:
		$Player.inventory  = $map.collect(targetAction)
	elif lastAction == ECONT.WALL || lastAction == ECONT.NONE:
		if $map.build(targetAction, $Player.inventory):
			$Player.inventory = -1
	$inventory.put($Player.inventory)
	pass

func setBallon(ballon, active, dmg):
	var inc = ballon if active else 0
	if ballon == 1:
		$up.makeVisible(inc, dmg)
	elif ballon == 2:
		$right.makeVisible(inc, dmg)
	elif ballon == 3:
		$down.makeVisible(inc, dmg)
	elif ballon == 4:
		$left.makeVisible(inc, dmg)

func initBalance():
	# Balance params
	waveSideProb = [
		20
		, 60
	]
	waveMinTime = 5
	waveMaxTime = 10
	
	waveStrProb = [
		70
		, 10
		, 5
		, 5
		, 1
	]
	
	waveMinStr = 1
	waveMaxStr = 9

func prepareNextWave():
	var sideRand = (randi()%100)
	if sideRand < waveSideProb[0]:
		nextWaveSide = nextWaveSide
	elif sideRand < waveSideProb[0] + waveSideProb[1]:
		if randi()%2 == 0:
			nextWaveSide = (nextWaveSide + 1) %4
		else:
			nextWaveSide = (nextWaveSide - 1) %4
	else:
		nextWaveSide = (nextWaveSide + 2)%4
	
	if nextWaveSide == 0:
		nextWaveSide = 4
	
	var strRand = (randi()%100)
	nextWaveStr = waveMinStr
	var prob = waveStrProb[0]
	for i in range (1, 5):
		prob += waveStrProb[i]
		if strRand > prob:
			nextWaveStr += 1
	if nextWaveStr > waveMaxStr:
		nextWaveStr = waveMaxStr
	timelapse = 0
	var offset = waveMaxTime - waveMinTime
	nextTime = (randi()%(offset)) + waveMinTime

func hardUp():
	var rand = (randi()%100)
	if rand == 0: # 1% chance
		waveMinStr += 1
	elif rand == 99: # 1% chance
		waveMinTime -= 1
		if waveMinTime == 0:
			waveMinTime = 1
	elif rand > 9 and rand  < 20: # 10% chance
		if waveSideProb[0] > 0:
			waveSideProb[1] +=5
			waveSideProb[0] -=5
	elif rand > 39 and rand  < 45: # 5% chance
		if waveSideProb[1] > 0:
			waveSideProb[1] -=5
	pass
