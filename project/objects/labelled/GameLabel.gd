extends Label
class_name GameLabel

signal label_activated(pressed)

export (String) var label setget set_label
export (LabelHelper.HAND) var hand = LabelHelper.HAND.LEFT
var parent setget , _parent

func _ready():
	set_process_unhandled_key_input(true)

func set_label(_label):
	label = _label
	text = label

func _parent():
	return get_parent()

func _enter_tree():
	#Get a random label
	set_label(LabelHelper.get_random_label(hand))

func _exit_tree():
	#Return our label
	LabelHelper.replace_label(label)

func _unhandled_key_input(event):
	#Get the character of the key input
	if event.echo:
		return
	
	var key = OS.get_scancode_string(event.scancode)
	var matches_label = key == label
	if matches_label:
		#Do we activate?
		emit_signal("label_activated", event.pressed)
