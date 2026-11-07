class_name VolumeSlider
extends HSlider



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    AudioServer.set_bus_volume_db(0, linear_to_db(value))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    AudioServer.set_bus_volume_db(0, linear_to_db(value))
