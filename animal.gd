extends Node2D

@onready var grid = get_parent()

var pos: Vector2 = Vector2(0,0) :
	get: return pos;
	set(value):
		var oldpos = position
		grid.grid[pos] = null
		pos = value
		grid.grid[pos] = self
		var tween = create_tween()
		tween.tween_property(self, "position", grid.grid_to_world(value), Parameters.move_tween_speed)

var data
var base_hp: float
var hp: float
var ap: float
var ap_per_turn: float
var attack: float
var initiative: int
var sight: float

var hunger: float = 0
var max_hunger: float = 10
var hunger_gain: float = 1.0

var is_player: bool = false

func initialize(_data, _is_player: bool = false):
	data = _data
	$Icon.text = _data.name[0]
	base_hp = randf_range(data.base_hp_min, data.base_hp_max)
	hp = base_hp
	ap = 0
	ap_per_turn = randf_range(data.min_ap_per_turn, data.max_ap_per_turn)
	attack = data.attack
	initiative = randi_range(data.min_initiative, data.max_initiative)
	is_player = _is_player
	$Panel/NameLabel.text = data.name
	$Panel/HPLabel.text = "HP: %s/%s" % [snapped(hp, .01), snapped(base_hp, .01)]
	$Panel/AttackLabel.text = "Attack: %s" % snapped(attack, .01)
	$Panel/APLabel.text = "Recovery: %s" % snapped(ap_per_turn, .01)

func _on_button_pressed():
	$Panel.visible = !$Panel.visible

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		$Panel.visible = false

# MOVEMENT AND ATTACK -----
func move(_pos: Vector2):
	if ap > data.move_cost:
		pos = _pos

# AI -----
var target_pos = null
var prey = null
var fleeing_from = null

var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2(-1,-1), Vector2(1,1), Vector2(-1,1), Vector2(1,-1)]

enum STATE {
	IDLE_WANDER
	, FLEE
	, CHASE
}

var state = STATE.IDLE_WANDER

func on_turn():
	ap += ap_per_turn
	match state:
		STATE.IDLE_WANDER:
			$Panel/ActionLabel.text = "Wandering"
			move(get_random_neighbor())
		STATE.FLEE:
			$Panel/ActionLabel.text = "Fleeing"
		STATE.CHASE:
			$Panel/ActionLabel.text = "Chasing"

func get_random_neighbor() -> Vector2:
			var target_dir = directions[randi() % directions.size()]
			var target_grid = pos + target_dir
			if grid.grid.has(target_grid) and grid.grid[target_grid] == null:
				return target_grid
			return get_random_neighbor()
