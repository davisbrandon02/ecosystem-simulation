extends Node2D

@onready var _grid = get_parent()

var pos: Vector2 = Vector2(0,0) :
	get: return pos;
	set(value):
		_grid.grid[pos] = null
		pos = value
		_grid.grid[pos] = self
		position = _grid.grid_to_world(pos)

var is_vegetable: bool = true
var amount

func initialize(_amount: int, _is_vegetable = true):
	amount = _amount
	is_vegetable = _is_vegetable

func _ready():
	$Icon.text = "{V}" if is_vegetable else "{M}"
	$Panel/NameLabel.text = "Vegetable" if is_vegetable else "Meat"
	$Panel/AmountLabel.text = "Amount: %s" % amount

func _on_button_pressed():
	$Panel.visible = !$Panel.visible
