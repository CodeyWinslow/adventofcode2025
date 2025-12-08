extends Label

@export var knob : Knob

func _ready():
	on_zeroed()
# Called when the node enters the scene tree for the first time.
func on_zeroed():
	text = str(knob.GetTimesZeroed())
