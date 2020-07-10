tool
extends Area2D
class_name Hook

export (int) var radius = 10 #px
export (Color) var color = Color.aliceblue
export (Color) var active_color = Color.orange

var active = false

func _ready():
	($CollisionShape2D.shape as CircleShape2D).radius = radius
	set_process_unhandled_key_input(true)

func _draw():
	var draw_color = active_color if active else color
	draw_circle(Vector2.ZERO, radius, draw_color)

func _unhandled_key_input(event):
	#Get the character of the key input
	if event.echo:
		return
	
	var key = OS.get_scancode_string(event.scancode)
	var matches_label = key == $GameLabel.label
	if matches_label:
		#Do we activate?
		active = event.pressed
		update()
