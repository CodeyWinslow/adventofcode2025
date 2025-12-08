extends Node
class_name Solver

var moves: Array
var current_move: int = 0
var current_position: int = 50
var number_zeroed: int = 0

const FILE_PATH = "res://data/day1/input.txt"

func _ready():
	_read_input()

func GetNextMove():
	if IsFinished():
		return Move.new()
	
	var move = moves[current_move]
	current_move += 1
	return move
	
func IsFinished():
	return current_move >= len(moves)

func process_move(position: int, move: Move):
	var delta: int = 1
	if move.direction == Move.MoveDirection.Left:
		delta = -1
		
	delta *= move.amount
	return wrapi(position + delta, 0, 100)
	
func _read_input():
	var text := ""
	
	var f := FileAccess.open(FILE_PATH, FileAccess.READ)
	if f:
		text = f.get_as_text()
	else:
		push_error("Could not open file: %s" % FILE_PATH)
		DisplayServer.dialog_show("Error", "Could not open file: %s" % FILE_PATH, PackedStringArray(["OK"]), error_message_ok_pressed)
		return

	var lines := text.split("\n", false)

	for line in lines:
		_process_input_line(line)
		
	print("Parsed %d moves from input file" % [len(moves)])

func error_message_ok_pressed():
	pass
		
func _process_input_line(line: String):
	var move: Move = Move.new()
	if line.begins_with('L'):
		move.direction = Move.MoveDirection.Left
	else:
		move.direction = Move.MoveDirection.Right
		
	move.amount = line.substr(1, -1).to_int()
	
	moves.append(move)
