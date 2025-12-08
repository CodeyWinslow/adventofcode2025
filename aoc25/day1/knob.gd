extends Sprite2D
class_name Knob

signal on_zeroed
signal on_complete(times_zeroed : int)

var amount_to_rotate : float = 0
var current_position : int = 50
var current_direction : int = 1 # 1 is right, -1 is left
var times_zeroed : int = 0
var running : bool = true

@export var solver : Solver
@export var time_to_spin = 0.5
@export var wait_time = 0.1

func GetTimeToSpin():
	return time_to_spin
	
func SetTimeToSpin(spin_time : float):
	time_to_spin = spin_time
	
func GetTimesZeroed():
	return times_zeroed
	
func QuickSolve():
	running = false
	
	while !solver.IsFinished():
		var move : Move = solver.GetNextMove()
		current_direction = 1 if move.direction == Move.MoveDirection.Right else -1
		change_position(solver.process_move(current_position, move))
		
	if amount_to_rotate > 0:
		amount_to_rotate = 0
		on_finished_rotation()
		
	on_complete.emit(times_zeroed)

func _ready():
	rotation_degrees = 0
	
	while running:
		await get_tree().create_timer(time_to_spin + wait_time).timeout
		
		if !running or solver.IsFinished():
			running = false
			break
		
		var move : Move = solver.GetNextMove()
		current_direction = 1 if move.direction == Move.MoveDirection.Right else -1
		change_position(solver.process_move(current_position, move))
		
	on_complete.emit(times_zeroed)

func _process(delta):
	if amount_to_rotate > 0:
		var has_finished_rotation = false
		
		var speed = 360.0 / time_to_spin
		var rotation_this_frame = delta * speed
		
		if rotation_this_frame > amount_to_rotate:
			rotation_this_frame = amount_to_rotate
			has_finished_rotation = true
			
		amount_to_rotate -= rotation_this_frame
		rotation_degrees += rotation_this_frame * current_direction
		
		if has_finished_rotation:
			on_finished_rotation()

func change_position(position : int):
	if amount_to_rotate > 0:
		on_finished_rotation()
	
	current_position = position
	
	if current_position == 0:
		times_zeroed += 1
	
	var next_rotation_angle = knob_position_to_rotation(current_position)
	print("Rotating %s to angle %f for position %d" % ["RIGHT" if current_direction == 1 else "LEFT", next_rotation_angle, position])
	amount_to_rotate = get_amount_to_rotate(rotation_degrees, next_rotation_angle, current_direction)
	
func on_finished_rotation():
	if current_position == 0:
		on_zeroed.emit()
	
func knob_position_to_rotation(position : int)->float:
	return float(position) / 100.0 * 360.0

func get_amount_to_rotate(from:float, to:float, direction:int): # right is 1, left is -1
	var from_wrapped = wrapf(from, 0, 360.0)
	var to_wrapped = wrapf(to, 0, 360.0)
	
	var delta = to_wrapped - from_wrapped
	
	if sign(delta) != sign(direction):
		delta += 360.0 * sign(direction)
		
	return abs(delta)
