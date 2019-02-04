extends Sprite

var animFrame = 0
var timelapse = 0
var side = true
var inc = 1
export (float) var animSpeed = 1
export (bool) var once = false
export (bool) var reverse = false
export (int) var animOffset = 0
export (int) var animSize = 5

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    self.animFrame = 0
    self.frame = animFrame
    timelapse = 0
    set_process(true)

func _process(delta):
    # Called every frame. Delta is time since last frame.
    # Update game logic here.
    timelapse += delta
    if timelapse > animSpeed:
        if reverse and side and (animFrame + 1) == animSize:
            inc = -1
            side = false
        if reverse and !side and (animFrame - 1) == 0:
            inc = 1
            side = true
            if once:
                set_process(false)
        if !reverse and side and once and (animFrame + 1) == animSize:
            set_process(false)
        timelapse = 0
        animFrame = animOffset + ((animFrame + inc) % animSize)
        self.frame = animFrame
        