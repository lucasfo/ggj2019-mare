extends AudioStreamPlayer

func _ready():
	pass

# Name of the file and volume in db(-80, 0)
func play_sfx(sfx_name, volume):
	var audio_file = "res://audio/" + sfx_name + ".wav"
	
	# Check if file is not ogg instead of wav
	if !File.new().file_exists(audio_file):
		audio_file = "res://audio/" + sfx_name + ".ogg"
	
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load(audio_file)
	player.volume_db = volume
	player.play()

# For tests
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		play_sfx("wave1", -10)
	elif Input.is_action_just_pressed("ui_right"):
		play_sfx("wave1", 0)