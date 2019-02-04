extends Node2D

signal endMoviment

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var gridPos = Vector2(0,0)
export (float) var secMove = 0.5
var move = Array()
var mat = -1
var inventory = -1;
var direction=1
var anim = ""


func setpos(newpos):
	gridPos = newpos
	position = Vector2(newpos.y*16, newpos.x*16)

func setMove(moves):
	if move.empty():
		for i in moves:
			move.append(i)
		_start_move()
	else:
		move.clear()
		for i in moves:
			move.append(i)

func _ready():
	anim="IdleD"

func _process(delta):
	if !$AnimationPlayer.is_playing() || $AnimationPlayer.get_current_animation() != anim:
		$AnimationPlayer.play(anim)

func _start_move():
	if !move.empty():
		var i = move.front()
		if i.y != gridPos.y:
			if i.y < gridPos.y && direction != 2:
				direction=2
				anim="WalkL"
			elif i.y > gridPos.y && direction != 0:
				direction=0
				anim="WalkR"
		elif i.x!=gridPos.x:
			if i.x < gridPos.x && direction != 3:
				direction=3
				anim="WalkU"
			elif i.x > gridPos.x && direction != 1:
				direction=1
				anim="WalkD"
		$Tween.interpolate_property( self, "position", revVector(gridPos*16), revVector(i*16), secMove , Tween.TRANS_LINEAR, Tween.EASE_OUT )
		gridPos = i
		$Tween.start()


func _on_Tween_tween_completed(object, key):
	if !move.empty():
		move.pop_front()
		
	if move.empty():
		emit_signal("endMoviment")
		if direction == 0:
			anim="IdleR"
		elif direction == 1:
			anim = "IdleD"
		elif direction == 2:
			anim = "IdleL"
		elif direction == 3:
			anim = "IdleU"
		pass
	else:
		_start_move()

func revVector(v):
	return Vector2(v.y, v.x)
