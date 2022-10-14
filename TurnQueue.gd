extends Node

var queue = []

@onready var game = get_parent()
@onready var grid = game.get_node("Grid")

func create_queue():
	queue.clear()
	
	var unqueued = grid.get_children()
	
	for animal_count in unqueued.size():
		var highest = get_highest_initiative_animal(unqueued)
		queue.append(highest)
		unqueued.erase(highest)

func get_highest_initiative_animal(_animal_list: Array):
	var highest_initiative: int = 0
	var highest_list: Array = []
	for a in _animal_list:
		if a.initiative > highest_initiative:
			highest_list.clear()
			highest_list.append(a)
		elif a.initiative == highest_initiative:
			highest_list.append(a)
	return highest_list[randi() % highest_list.size()]
