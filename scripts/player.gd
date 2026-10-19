class_name Player
extends Node3D

@export var rotationSpeed: float=1.0
@onready var fader:AudioFader=$AudioFader
@onready var viewRay:RayCast3D=$PlayerCamera/RayCast3D
var gameState
var mouse_clicked: bool=false

var crane_button_force_target: float = 0.0
@export var crane_button_force_current:float=0.0
var mode_timer:float=0
@export var allButtons:Array[PlayerButton] 

@export var curve_accelaration:Curve 
@export var acceleration_speed: float=0.9
@export var curve_decelaration:Curve 
@export var deceleration_speed: float=2.1337

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    mode_timer=0
    mouse_clicked=false
    gameState = $/root/Game/GameState
    reset_buttons()
    
    curve_accelaration.bake()
    curve_decelaration.bake()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var rotation_current := crane_button_force_current
    var rotation_target := crane_button_force_target
    var is_accelerating: bool = (absf(rotation_target) > absf(rotation_current) and rotation_current * rotation_target >= 0.0)
    var speed: float = acceleration_speed if is_accelerating else deceleration_speed
    crane_button_force_current = move_toward(rotation_current,rotation_target, speed * delta)

    rotate(Vector3.UP, crane_button_force_current * rotationSpeed * delta)
    gameState.player_rotation = rotation.y
    
    if crane_button_force_current == 0.0:
        fader.stop()
    else:
        fader.play()
    
    # mode_timer+=delta
    # var curve:Curve
    # var speed:float
    # if crane_button_force_target==0:
    #     curve = curve_decelaration
    #     speed=acceleration_speed
    # else:
    #     curve = curve_accelaration
    #     speed=deceleration_speed
    # var c:float = curve.sample(min(mode_timer*speed,1))
    
    var valid_target: bool = false
    var focussed_button:PlayerButton = null
    
    if viewRay.is_colliding():
        var target: Object=viewRay.get_collider()
        if is_instance_of(target,PlayerButton):
            valid_target=true
            focussed_button=target
            
    gameState.is_player_hover_over_interactable=focussed_button!=null
        
    if mouse_clicked and valid_target:
        reset_buttons()
        focussed_button.press()
    
        if focussed_button.buttonType == PlayerButton.ButtonType.UNBEKANNT:
            pass
            print("UNBEKANNTER BUTTON GEDRÜCKT!!!")
        if focussed_button.buttonType == PlayerButton.ButtonType.START_LINKS:
            crane_button_force_target=-1.0
            mode_timer=0
        if focussed_button.buttonType == PlayerButton.ButtonType.START_RECHTS:
            crane_button_force_target=1.0
            mode_timer=0
        if focussed_button.buttonType == PlayerButton.ButtonType.STOP:
            crane_button_force_target=0.0
            mode_timer=0
        if focussed_button.buttonType == PlayerButton.ButtonType.MAGNET:
            print("mm")
            pass
            
    mouse_clicked = false
        
func reset_buttons():
    for button:PlayerButton in allButtons:
        button.is_pressed=false

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index ==MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
            mouse_clicked=true
