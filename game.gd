extends Node2D

@export var animal_count: int = 5

@onready var grid = $Grid
@onready var pf = $Pathfinding
@onready var tq = $TurnQueue

# Initializes the game
func _ready():
	randomize()
	$Grid.generate_grid()
	generate_animals()

func generate_animals() -> void:
	for i in animal_count:
		var rand_animal_data = AnimalDB.get_random_animal()
		var animal_instance = preload("res://animal.tscn").instantiate()
		animal_instance.initialize(rand_animal_data)
		$Grid.add_child(animal_instance) 
		animal_instance.pos = $Grid.get_random_pos()

func run_iteration():
	tq.create_queue()
	for animal in tq.queue:
		animal.on_turn()
	$GUI/PassTimeButton.visible = true


# SIMULATION SPEED -----
var paused: bool = true
var speed = [1.5, .75, .375, .1875]
@onready var timer: Timer = get_node("TurnTimer")

func _on_pass_time_button_pressed():
	$GUI/PassTimeButton.visible = false
	run_iteration()

func _on_pause_pressed():
	paused = true
	timer.stop()

func _on_speed_1_pressed():
	timer.wait_time = speed[0]
	timer.start()

func _on_speed_2_pressed():
	timer.wait_time = speed[1]
	timer.start()

func _on_speed_3_pressed():
	timer.wait_time = speed[2]
	timer.start()

func _on_speed_4_pressed():
	timer.wait_time = speed[3]
	timer.start()

func _on_turn_timer_timeout():
	run_iteration()
