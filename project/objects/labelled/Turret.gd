tool
extends Area2D
class_name Turret

signal launched_rocket(turret)

var launch_time_range = Vector2(10, 15) # Min/Max launch time base
var launch_time_speedup = 0.25 # How much quicker it launches per 'difficulty'
var difficulty = 0

onready var sprite = $PlatformSprite/CannonSprite
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player").pop_back()
	
	#Get all turret listeners
	for listener in get_tree().get_nodes_in_group("turret_listener"):
		connect("launched_rocket", listener, "_on_Turret_launched_rocket", [self])
	
	set_process(true)
	_launch()

func _process(delta):
	
	#Have the cannon face the player
	if player:
		sprite.rotation = (player.global_position - global_position).normalized().angle() + PI/2

func _launch():
	#Pick a new time
	var launch_time = rand_range(launch_time_range.x, launch_time_range.y)
	launch_time -= launch_time_speedup * difficulty
	
	#Run the timer...
	$Timer.start(launch_time)
	yield($Timer, "timeout")
	
	#Launch a missle
	emit_signal("launched_rocket")
	
	#Start again!
	_launch()
	
