class_name GameState
extends Node3D

@export var player_rotation: float=0.0
var is_player_hover_over_interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_magnet_button_pressed():
	print("gamestate: magnet pressed")
	pass
