class_name Player
extends Node3D

@export var rotationSpeed: float=1.0
@onready var viewRay:RayCast3D=$PlayerCamera/RayCast3D
var gameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameState = $/root/Game/GameState


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rot: int=0
	# Check player input
	if Input.is_key_pressed(KEY_A):
		#print('A')
		rot=1
		
	if Input.is_key_pressed(KEY_D):
		#print('D')
		rot=-1
		
	rotate(Vector3.UP,rot*rotationSpeed*delta)
	gameState.player_rotation=rotation.y
	
	var valid_target = false
	if viewRay.is_colliding():
		var target: Object=viewRay.get_collider()
		# print(target)
		if is_instance_of(target,PlayerConsoleButton):
			print("console")
			valid_target=true
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and valid_target:
		pass

		
