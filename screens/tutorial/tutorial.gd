extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var status = true

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    $back.connect("button_down", self, "comeBack")
    $flip.connect("button_down", self, "flip")
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func comeBack():
    get_tree().change_scene("res://screens/menu/menu.tscn")
    pass

func flip():
    if status:
        $frame1.visible = false
        $frame2.visible = true
        status = false
    else:
        $frame1.visible = true
        $frame2.visible = false
        status = true
