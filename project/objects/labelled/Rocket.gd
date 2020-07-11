extends Area2D

export var rocket_explosion = "res://objects/explosion.png"
onready var _rocket_explosion = load(rocket_explosion)

var kill_time = 0.5 #Seconds of holding the key
var _kill_time = kill_time
var active = false

var rocket_force = 0.3 # Velocity per second
var current_velocity = 0.15
var velocity = Vector2.ZERO
var direction = Vector2.ONE
var max_velocity = 7

var player = null
onready var sprite = $Sprite


func _ready():
	player = get_tree().get_nodes_in_group("player").pop_back()
	if player:
		velocity = (player.global_position - global_position).normalized() * current_velocity
	
	
	set_process(true)
	
func _process(delta):
	if active:
		_kill_time -= delta
	
	#Did we die?
	if _kill_time < 0:
		_kill()
		_kill_time = 99999
		velocity = Vector2.ZERO
		current_velocity = Vector2.ZERO
		set_process(false)
		modulate = Color.white
		monitorable = false
		monitoring = false
		return
		
		
	#How much health left on the rocket?
	var life_percent = _kill_time / kill_time
	var color = lerp(0, 1, life_percent)
	modulate = Color(color, color, color)
	
	#Sprite always faces at player
	if player:
		sprite.rotation = (player.global_position - global_position).normalized().angle() + PI/2
		
		#Move the rocket towards the player
		direction = (player.global_position - global_position).normalized()
	
	#Make sure we don't exceed max speed
	current_velocity += rocket_force * delta
	velocity = direction * current_velocity
	velocity = velocity.clamped(max_velocity)
	position += velocity

func _kill():
	#Wait for both an explosion animation to play and the explosion sound
	print("Rocket dead")
	
	sprite.texture = _rocket_explosion
	
	$AudioStreamPlayer2D.play()
	yield($AudioStreamPlayer2D, "finished")
	
	queue_free()

func _on_GameLabel_label_activated(pressed):
	active = pressed
