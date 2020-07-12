extends Area2D

signal player_died

export (float) var radius = 10
export (Color) var color = Color.beige
export var explosion = "res://objects/explosion.png"
var _explosion = load(explosion)

export (float) var hook_force = 4
export (float) var max_speed = 4
export (float, 0, 2) var drag = 0.5

var latched_node = null
var velocity = Vector2(0, 0)
var alive = true

onready var player_sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	($CollisionShape2D.shape as CircleShape2D).radius = radius
	set_physics_process(true)
	

func _physics_process(delta):
	
	if not alive:
		velocity = Vector2.ZERO
		return
	
	#Are we latched onto a hook?
	if latched_node and latched_node.active:
		velocity = Vector2.ZERO
	else:
		#Start flying around
		player_sprite.play("idle")
		_integrate_active_hooks()
	
	#Make sure we don't exceed max speed
	velocity = velocity.clamped(max_speed)
	position += velocity
	
	if velocity.x>0:
		player_sprite.flip_h = false
	else:
		player_sprite.flip_h = true
	
	#Drag velocity (when drifting only!)
	velocity = velocity * (1 - drag * delta)
	
func _integrate_active_hooks():
	#Get all of the active hooks
	var active_hooks = []
	for hook in get_tree().get_nodes_in_group("hook"):
		if hook.active:
			active_hooks.append(hook)

	#Pull towards active hooks
	if active_hooks.size():
		player_sprite.play("pull")
		velocity = Vector2.ZERO
		for hook in active_hooks:
			_integrate_hook(hook)

func _integrate_hook(hook):
	
	#Create a force towards the hook
	var direction = (hook.global_position - global_position).normalized()
	var force = direction * hook_force
	velocity = velocity + force

func _die():
	if not alive:
		return
	print("YOU DIED!!!!")
	emit_signal("player_died")
	player_sprite.play("die")
	$AudioStreamPlayer2D.play()
	
	alive = false


func _draw():
	draw_circle(Vector2.ZERO, radius, color)


func _on_Player_area_entered(area):
	#Is this a hook we've latched on to willingly?
	
	if area.is_in_group('hook'):
		area = area as Hook
		latched_node = area
	
	if area.is_in_group("deadly"):
		#Take some damage
		_die()
		area._kill()


func _on_Player_area_exited(area):
	if area == latched_node:
		latched_node = null
