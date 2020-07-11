extends Position2D

signal spawned_turret(spawner)

const TurretScene = preload("res://objects/labelled/Turret.tscn")

onready var alert = $Alert

func _ready():
	remove_child(alert)
	for listener in get_tree().get_nodes_in_group("turret_spawn_listener"):
		connect("spawned_turret", listener, "_on_TurretSpawner_spawned_turret", [self])

func trigger_spawn():
	add_child(alert)
	alert._blink()
	yield(alert, "alert_finished")
	emit_signal("spawned_turret")
	queue_free()
