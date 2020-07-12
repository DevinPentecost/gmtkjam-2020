tool
extends Area2D
class_name Hook

export (int) var radius = 10 #px
export (Color) var color = Color("#126f7e")
export (Color) var active_color = Color("#c9ad23")

var active = false
onready var hole_sprite = get_node("Sprite")

onready var alert = $Alert

func _ready():
	($CollisionShape2D.shape as CircleShape2D).radius = radius
	remove_child(alert)

func relabel():
	
	add_child(alert)
	#alert._blink()
	#yield(alert, "alert_finished")
	
	$GameLabel.label = LabelHelper.swap_label($GameLabel.label)

func _draw():
	var draw_color = active_color if active else color
	draw_circle(Vector2.ZERO, radius, draw_color)
	
	if active:
		hole_sprite.play("active")
	else:
		hole_sprite.play("idle")

func _on_GameLabel_label_activated(pressed):
	active = pressed
	update()
