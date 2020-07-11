extends Sprite

signal alert_finished(alert)

export (float) var blink_time = 0.5
export (int) var blink_count = 5
var _blink_count = 0

onready var timer = $Timer
onready var player = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_blink()

func _exit_tree():
	player.stop()
	timer.stop()

func _blink():
	#Increment blink count
	_blink_count += 1
	
	#Determine visibility
	var visibility = _blink_count % 2 == 1
	visible = visibility
	
	#Do we play a sound?
	if visibility:
		player.play()
		
	#Wait for the next blink
	timer.start(blink_time)
	yield(timer, "timeout")
	
	#Are we done?
	if _blink_count == blink_count:
		visible = false
		emit_signal("alert_finished")
	else:
		_blink()
	
