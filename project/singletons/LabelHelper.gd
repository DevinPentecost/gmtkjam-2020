extends Node

var LABELS_STRING = 'QWERTYUIOPASDFGHJKLZXCVBNM'
var UNUSED_LEFT = []
var UNUSED_RIGHT = []

var LEFT_LABELS = 'QWERTASDFGZXCVB'
var RIGHT_LABELS = 'YUIOPHJKLNM'
enum HAND {
	LEFT,
	RIGHT
}


func _enter_tree():
	#Set up labels
	for label in LEFT_LABELS:
		UNUSED_LEFT.append(label)
	for label in RIGHT_LABELS:
		UNUSED_RIGHT.append(label)

func get_label_nodes():
	return get_tree().get_nodes_in_group("game_label")

func get_labelled_nodes(parent_group=null):
	var labelled_nodes = []
	
	#Get all of the label node parents
	for label in get_label_nodes():
		var parent = label.parent
		
		#Do we need to check the group of the parent?
		if parent_group == null or parent_group in parent.groups():
			labelled_nodes.append(parent)
	
	return labelled_nodes
	
func get_current_labels():
	var labels = []
	for label in get_label_nodes():
		labels.append(label.label)
	return labels

func get_random_label(hand=HAND.LEFT, replace=false):
	
	#Pull a random label from the bag
	var bag = null
	if hand == HAND.LEFT:
		bag = UNUSED_LEFT
	elif hand == HAND.RIGHT:
		bag = UNUSED_RIGHT
		
	var label_index = randi() % bag.size()
	var label = bag[label_index]
	
	#Remove it from the bag
	if not replace:
		bag.remove(label_index)
	return label

func replace_label(label):
	#Put it back in the bag
	if label in LEFT_LABELS:
		UNUSED_LEFT.append(label)
	elif label in RIGHT_LABELS:
		UNUSED_RIGHT.append(label)
	else:
		#Where did this label come from?
		pass

func swap_label(label, hand=HAND.LEFT):
	#Get a new label
	var new_label = get_random_label(hand)
	replace_label(label)
	return new_label
