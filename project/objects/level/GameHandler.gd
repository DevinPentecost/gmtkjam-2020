extends Node2D

const RocketScene = preload("res://objects/labelled/Rocket.tscn")
const TurretScene = preload("res://objects/labelled/Turret.tscn")

export (float) var turret_spawn_interval = 30 # Seconds to spawn a new one
export (float) var relabel_hooks_interval = 20 # Seconds to do a hook relable
export (float) var difficulty_increase_interval = 45 # Seconds to increase difficulty

var difficulty = 1

onready var player = $Player

onready var turrets = $Turrets
onready var hooks = $Hooks
onready var obstacles = $Obstacles

onready var turret_timer = $TurretTimer
onready var relabel_timer = $RelabelTimer
onready var difficulty_timer = $DifficultyTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_turret()
	_relabel_hooks()
	_increase_difficulty()

func _on_Turret_launched_rocket(turret):
	
	#We create a new rocket
	var new_rocket = RocketScene.instance()
	new_rocket.global_position = turret.global_position
	
	#Add it
	add_child(new_rocket)

func _spawn_turret():
	
	#Pick a turret spawner
	var spawners = get_tree().get_nodes_in_group("turret_spawner")
	if spawners.size() == 0:
		#We're done
		turret_timer.queue_free()
		return
	
	#Pick a spawner at random
	var spawner = spawners[randi() % spawners.size()]
	spawner.trigger_spawn()
	
	#Wait for the timer
	turret_timer.start(turret_spawn_interval)
	yield(turret_timer, "timeout")
	
	_spawn_turret()

func _relabel_hooks():
	relabel_timer.start(relabel_hooks_interval)
	yield(relabel_timer, "timeout")
	
	#Pick some hooks at random
	for count in range(difficulty):
		var hook = hooks.get_children()[randi()%hooks.get_child_count()]
		hook.relabel()
	
	_relabel_hooks()
	
func _increase_difficulty():
	difficulty_timer.start(difficulty_increase_interval)
	yield(difficulty_timer, "timeout")
	difficulty += 1
	
	#Increase the difficulty of all current turrets!
	for turret in get_tree().get_nodes_in_group("turret"):
		turret.difficulty = difficulty
	
	_increase_difficulty()

func _on_TurretSpawner_spawned_turret(spawner):
	#Make a new turret
	var new_turret = TurretScene.instance()
	new_turret.global_position = spawner.global_position
	
	#Add it to our collection
	turrets.add_child(new_turret)

