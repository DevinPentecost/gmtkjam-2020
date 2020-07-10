extends Area2D

export (float) var radius = 25


# Called when the node enters the scene tree for the first time.
func _ready():
	($CollisionShape2D.shape as CircleShape2D).radius = radius


func _draw():
	draw_circle(Vector2.ZERO, radius, Color.red)
