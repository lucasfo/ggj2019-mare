extends Control

var highscores = {
	"players": ["Player", "Player", "Player", "Player", "Player"],
	"scores": [0, 0, 0, 0, 0]
}
var return_scene = "res://screens/menu/menu.tscn"

var scoreFromGame = 22

func _ready():
	load_scores()
	# Set score
	var score = scoreFromGame
	get_node("PlayerScore").set_text("SUA PONTUACAO: " + String(score))

func save_scores(player_name, player_score):
	# Open a file
	var file = File.new()
	if file.open("user://saved_game.save", File.WRITE) != 0:
    	print("Error opening file")
    	return
	
	for i in range(0, 5):
		if player_score > highscores.scores[i]:
			var j = 4
			while j > i:
				highscores.players[j] = highscores.players[j - 1]
				highscores.scores[j] = highscores.scores[j - 1]
				j = j - 1
			highscores.players[j] = player_name
			highscores.scores[j] = player_score
			break
	
	# Save the dictionary as JSON (or whatever you want, JSON is convenient here because it's built-in)
	# print(highscores["players"])
	# print(highscores["scores"])
	file.store_line(to_json(highscores))
	file.close()
	print("Saved")

func load_scores():
	# Check if there is a saved file
	var file = File.new()
	if  file.file_exists("user://saved_game.save"):
		# Open existing file
		if file.open("user://saved_game.save", File.READ) != 0:
    		print("Error opening file")
    		return

		# Get the data
		var text = file.get_as_text()
		var dict = parse_json(text)
		highscores = dict
		
		#if dict == null:
		#	highscores.players = ["Player", "Player", "Player", "Player", "Player"]
		#	highscores.scores = [0, 0, 0, 0, 0]
	# Then do what you want with the data
	for i in range(0, 5):
		var player_score = String(highscores.scores[i])
		get_node("VBoxContainer2").get_child(i).set_text(player_score + " - " + highscores.players[i])

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene(return_scene)

func _on_SaveButton_pressed():
	var player_name = get_node("LineEdit").get_text()
	var score = scoreFromGame # GET SCORE
	var player_score = String(score)
	get_node("LineEdit").hide()
	get_node("InputText").hide()
	get_node("InputText2").hide()
	get_node("SaveButton").hide()
	save_scores(player_name, score)
	load_scores()


func _on_LineEdit_focus_entered():
	get_node("InputText").show()
	get_node("InputText2").hide()


func _on_LineEdit_focus_exited():
	get_node("InputText").hide()
	get_node("InputText2").show()
	
func receiveScore(s):
	$PlayerScore.visible = true
	$InputText.visible = true
	$InputText2.visible = true
	$LineEdit.visible = true
	$SaveButton.visible = true
	scoreFromGame = s;

func _on_SairBotao_button_down():
	get_tree().change_scene(return_scene)
