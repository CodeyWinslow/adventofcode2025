extends Button

@export var knob : Knob

# Called when the node enters the scene tree for the first time.
func _pressed() -> void:
	knob.QuickSolve()
