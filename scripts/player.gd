class_name Player
extends Node3D

@export var rotationSpeed: float=1.0
@onready var viewRay:RayCast3D=$PlayerCamera/RayCast3D
var gameState

@export var craneButtonForce: float = 0.0
@export var allButtons:Array[PlayerButton] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameState = $/root/Game/GameState
	reset_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rot: int=0
	# Check player input
	# if Input.is_key_pressed(KEY_A):
	# 	#print('A')
	# 	rot=1
	# 	
	# if Input.is_key_pressed(KEY_D):
	# 	#print('D')
	# 	rot=-1
	rot=craneButtonForce
		
	rotate(Vector3.UP,rot*rotationSpeed*delta)
	gameState.player_rotation=rotation.y
	
	var valid_target = false
	var focussed_button:PlayerButton = null
	
	if viewRay.is_colliding():
		var target: Object=viewRay.get_collider()
		if is_instance_of(target,PlayerButton):
			valid_target=true
			focussed_button=target
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and valid_target:
		reset_buttons()
		focussed_button.press()
	
		if focussed_button.buttonType == PlayerButton.ButtonType.UNBEKANNT:
			print("UNBEKANNTER BUTTON GEDRÜCKT!!!")
		if focussed_button.buttonType == PlayerButton.ButtonType.START_LINKS:
			print("Button: Links")
			craneButtonForce=-1.0
		if focussed_button.buttonType == PlayerButton.ButtonType.START_RECHTS:
			print("Button: Rechts")
			craneButtonForce=1
		if focussed_button.buttonType == PlayerButton.ButtonType.STOP:
			print("Button: Stopp")
			craneButtonForce=0
		if focussed_button.buttonType == PlayerButton.ButtonType.MAGNET:
			print("Button: Magnet")
		
func reset_buttons():
	for button:PlayerButton in allButtons:
		button.is_pressed=false

		
