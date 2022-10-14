extends Node

var animals = {
	"Fox": preload("res://AnimalData/Fox.tres")
	, "Squirrel": preload("res://AnimalData/Squirrel.tres")
}

func get_random_animal() -> Resource:
	var a = animals.keys();
	var rand_key = a[randi() % a.size()]
	return animals[rand_key]
