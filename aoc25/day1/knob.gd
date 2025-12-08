extends Sprite2D
class_name Knob

var target_rotation : float = 0
var current_position : int = 50
var current_direction : int = 1 # 1 is right, -1 is left

@export var solver : Solver
@export var speed : float = 100.0

func _ready():
	rotation_degrees = target_rotation
	
	while true:
		await get_tree().create_timer(2).timeout
		var move : Move = solver.GetNextMove()
		current_direction = 1 if move.direction == Move.MoveDirection.Right else -1
		change_position(solver.process_move(current_position, move))

func _process(delta):
	var cur_rot = wrapf(rotation_degrees, 0, 360.0)
	var targ_rot = wrapf(target_rotation, 0, 360.0)
	
	if current_direction == 1:
		# moving right, target should be > current
		if targ_rot < cur_rot:
			targ_rot += 360
	elif targ_rot > cur_rot:
		# moving left, target should be < current
		targ_rot -= 360
	
	print("moving %s from %f to %f" % ["LEFT" if current_direction == -1 else "RIGHT", cur_rot, targ_rot])
		
	var rot_change = targ_rot - cur_rot
	var frame_change = sign(rot_change) * delta * speed
	var new_rotation = rotation_degrees + min(frame_change, rot_change)
	rotation_degrees= new_rotation

func change_position(position : int):
	print("setting knob position to %d" % [position])
	current_position = position
	target_rotation = knob_position_to_rotation(current_position)
	
func knob_position_to_rotation(position : int)->float:
	return float(position) / 100.0 * 360.0
