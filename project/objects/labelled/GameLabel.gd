extends Label
class_name GameLabel

export (String) var label setget set_label
export (LabelHelper.HAND) var hand = LabelHelper.HAND.LEFT
var parent setget , _parent

func set_label(_label):
	label = _label
	text = label

func _parent():
	return get_parent()

func _enter_tree():
	#Get a random label
	set_label(LabelHelper.get_random_label())

func _exit_tree():
	#Return our label
	LabelHelper.replace_label(label)
