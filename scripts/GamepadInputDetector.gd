class_name GamepadInputDetector
extends Node3D

signal input_mode_changed(gamepad_mode: bool)

@export var controller_stick_trigger_deadzone:float=0.1
@export var is_gamepad_mode: bool = false:
    set(value):
        if is_gamepad_mode == value:
            return

        is_gamepad_mode = value
        input_mode_changed.emit(value)
        print('Input mode has changed! Controller mode? -> '+str(is_gamepad_mode))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _input(event: InputEvent) -> void:
    # GAMEPAD
    if event is InputEventJoypadButton:
        if event.pressed:
            is_gamepad_mode = true

    elif event is InputEventJoypadMotion:
        if abs(event.axis_value) > controller_stick_trigger_deadzone:
            is_gamepad_mode = true

    # KEYBOARD
    elif event is InputEventKey:
        if event.pressed:
            is_gamepad_mode = false

    # MOUSE
    elif event is InputEventMouseButton:
        if event.pressed:
            is_gamepad_mode = false

    elif event is InputEventMouseMotion:
        if event.relative.length() > 2.0:
            is_gamepad_mode = false