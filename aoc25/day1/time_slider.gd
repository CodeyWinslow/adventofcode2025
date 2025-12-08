extends HSlider

@export var knob : Knob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_value_no_signal(knob.GetTimeToSpin())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _value_changed(new_value: float) -> void:
	knob.SetTimeToSpin(new_value)
